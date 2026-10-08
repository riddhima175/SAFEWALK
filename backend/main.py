from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime
import uuid

import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("pixel-76562-firebase-adminsdk-fbsvc-788d04d212.json")

firebase_admin.initialize_app(cred)
db = firestore.client()

app = FastAPI(title="SafeWalk Backend")


class JourneyStart(BaseModel):
    user_id: str
    destination: str
    arrival_time: str
    code_word: str


class JourneyResponse(BaseModel):
    journey_id: str
    response: str


class JourneyTimeout(BaseModel):
    journey_id: str
    tier: int


journeys_ref = db.collection("journeys")
alerts_ref = db.collection("alerts")


@app.get("/")
def home():
    return {
        "message": "SafeWalk backend is running",
        "status": "ok"
    }


@app.post("/journey/start")
def start_journey(data: JourneyStart):

    journey_id = str(uuid.uuid4())

    journey_data = {
        "journey_id": journey_id,
        "user_id": data.user_id,
        "destination": data.destination,
        "arrival_time": data.arrival_time,
        "code_word": data.code_word,
        "status": "active",
        "created_at": datetime.now().isoformat()
    }

    journeys_ref.document(journey_id).set(journey_data)

    return {
        "success": True,
        "journey_id": journey_id,
        "message": "Journey started"
    }


@app.post("/journey/respond")
def respond_to_journey(data: JourneyResponse):

    journey_doc = journeys_ref.document(data.journey_id).get()

    if not journey_doc.exists:
        return {
            "success": False,
            "message": "Journey not found"
        }

    journey = journey_doc.to_dict()

    if data.response == journey["code_word"]:
        journeys_ref.document(data.journey_id).update({
            "status": "safe"
        })

        return {
            "success": True,
            "status": "safe",
            "message": "Correct code word"
        }

    else:
        journeys_ref.document(data.journey_id).update({
            "status": "wrong_code"
        })

        alert_id = str(uuid.uuid4())

        alert_data = {
            "alert_id": alert_id,
            "journey_id": data.journey_id,
            "tier": 1,
            "type": "FAMILY_SMS",
            "created_at": datetime.now().isoformat()
        }

        alerts_ref.document(alert_id).set(alert_data)

        return {
            "success": True,
            "status": "wrong_code",
            "tier": 1,
            "alert_type": "FAMILY_SMS",
            "alert_id": alert_id,
            "message": "Incorrect code word - Tier 1 escalation triggered"
        }
@app.post("/journey/timeout")
def journey_timeout(data: JourneyTimeout):

    journey_doc = journeys_ref.document(data.journey_id).get()

    if not journey_doc.exists:
        return {
            "success": False,
            "message": "Journey not found"
        }

    if data.tier == 1:
        alert_type = "FAMILY_SMS"

    elif data.tier == 2:
        alert_type = "LIVE_LOCATION"

    elif data.tier == 3:
        alert_type = "NEARBY_USERS"

    else:
        return {
            "success": False,
            "message": "Invalid escalation tier"
        }

    alert_id = str(uuid.uuid4())

    alert_data = {
        "alert_id": alert_id,
        "journey_id": data.journey_id,
        "tier": data.tier,
        "type": alert_type,
        "created_at": datetime.now().isoformat()
    }

    alerts_ref.document(alert_id).set(alert_data)

    journeys_ref.document(data.journey_id).update({
        "current_tier": data.tier
    })

    return {
        "success": True,
        "tier": data.tier,
        "alert_type": alert_type,
        "alert_id": alert_id,
        "message": f"Tier {data.tier} escalation triggered"
    }


class LocationUpdate(BaseModel):
    journey_id: str
    latitude: float
    longitude: float


@app.post("/location")
def update_location(data: LocationUpdate):

    journey_doc = journeys_ref.document(data.journey_id).get()

    if not journey_doc.exists:
        return {
            "success": False,
            "message": "Journey not found"
        }

    journeys_ref.document(data.journey_id).update({
        "latitude": data.latitude,
        "longitude": data.longitude,
        "location_updated_at": datetime.now().isoformat()
    })

    return {
        "success": True,
        "message": "Location updated",
        "latitude": data.latitude,
        "longitude": data.longitude
    }


@app.post("/journey/check-escalation")
def check_escalation(journey_id: str):

    journey_doc = journeys_ref.document(journey_id).get()

    if not journey_doc.exists:
        return {
            "success": False,
            "message": "Journey not found"
        }

    journey = journey_doc.to_dict()

    if journey.get("status") == "safe":
        return {
            "success": True,
            "status": "safe",
            "message": "User is safe. No escalation needed."
        }

    current_tier = journey.get("current_tier", 0)
    next_tier = current_tier + 1

    if next_tier > 3:
        return {
            "success": True,
            "status": "maximum_escalation",
            "message": "Maximum escalation level reached"
        }

    if next_tier == 1:
        alert_type = "FAMILY_SMS"

    elif next_tier == 2:
        alert_type = "LIVE_LOCATION"

    else:
        alert_type = "NEARBY_USERS"

    alert_id = str(uuid.uuid4())

    alert_data = {
        "alert_id": alert_id,
        "journey_id": journey_id,
        "tier": next_tier,
        "type": alert_type,
        "created_at": datetime.now().isoformat()
    }

    alerts_ref.document(alert_id).set(alert_data)

    journeys_ref.document(journey_id).update({
        "current_tier": next_tier
    })

    return {
        "success": True,
        "tier": next_tier,
        "alert_type": alert_type,
        "alert_id": alert_id,
        "message": f"Tier {next_tier} escalation triggered"
    }