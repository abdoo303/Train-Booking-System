import base64
import time

from flask import Flask, request, jsonify,send_file
from datetime import datetime,timedelta
from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime,func,extract
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from utilities import *
from ticket_generator import book_ticket
from email_verifier import send_verification_email


app = Flask(__name__)

Base = declarative_base()

class User(Base):
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, index=True)
    national_id = Column(String, index=True)
    dob = Column(DateTime)
    govern = Column(String)
    gender = Column(String)
    phone_number = Column(String)
    password = Column(String)

class Ride(Base):
    __tablename__ = 'ride'
    ride_id  = Column(Integer,primary_key=True,index=True)
    from_station = Column(String, index=True)
    to_station = Column(String, index=True)
    train_name = Column(String)
    begin_time = Column(DateTime)
    end_time = Column(DateTime)
    price = Column(Float)
    class_ = Column(String)
    capacity = Column(Integer, default=0)
    num_booked = Column(Integer, default=0)

##################### fake rides ###################
rides_to_insert = [
    Ride(
        from_station="Cairo",
        to_station="Alexandria",
        train_name="Train1",
        begin_time=datetime(2023, 9, 7, 8, 0),  # Replace with your actual date and time
        end_time=datetime(2023, 9, 7, 10, 0),  # Replace with your actual date and time
        price=50.0,
        class_="Economy",
        capacity=2
    ),
    Ride(
        from_station="Cairo",
        to_station="Alexandria",
        train_name="Train2",
        begin_time=datetime(2023, 9, 12, 9, 0),
        end_time=datetime(2023, 9, 12, 11, 0),
        price=60.0,
        class_="Business",
        capacity=2

    ),
    Ride(
        from_station="Cairo",
        to_station="Alexandria",
        train_name="Train3",
        begin_time=datetime(2023, 9, 12, 10, 0),
        end_time=datetime(2023, 9, 12, 12, 0),
        price=70.0,
        class_="First Class",
        capacity=2
    ),
]


#######################################

class Ticket(Base):
    __tablename__ = 'ticket'
    ticket_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    from_station = Column(String, index=True)
    to_station = Column(String, index=True)
    train_name = Column(String)
    begin_time = Column(DateTime)
    end_time = Column(DateTime)
    class_ = Column(String)
    price = Column(Float)

# Define your database URL and create the engine and session
users_url = 'sqlite:///users.db'
trains_url = 'sqlite:///trains.db'
tickets_url = 'sqlite:///tickets.db'

users_engine = create_engine(users_url, echo=True)
trains_engine = create_engine(trains_url, echo=True)
tickets_engine = create_engine(tickets_url, echo=True)

UserSession = sessionmaker(bind=users_engine)
TrainsSession = sessionmaker(bind=trains_engine)
TicketsSession = sessionmaker(bind=tickets_engine)

# Create the tables in the database
Base.metadata.create_all(users_engine)
Base.metadata.create_all(trains_engine)
Base.metadata.create_all(tickets_engine)




@app.route("/")
def read_root():
    return jsonify({"message": "Hello, Flask!"})







@app.route("/signup/", methods=['POST'])
def create_hero():
    session = UserSession()
    incoming_data = request.json
    print(incoming_data)

    try:
        hero = processIncomingData(incoming_data)

        if hero.get('govern') == 'Wrong':
            return jsonify({"error": "National Id is incorrect. Please try again."}), 404

        check_user = session.query(User).filter_by(email=hero['email']).first()
        if check_user is not None:
            return jsonify({"error": "Email already signed in"}), 404

        check_user = session.query(User).filter_by(national_id=hero['national_id']).first()
        if check_user is not None:
            return jsonify({"error": "National ID already sgined in"}), 404



        db_hero = User(**hero)
        session.add(db_hero)
        session.commit()
        session.refresh(db_hero)
        return jsonify({"id": db_hero.id,'userName':db_hero.name,'email':db_hero.email,'phoneNumber':db_hero.email}), 200

    except Exception as e:
        session.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        session.close()


@app.route("/signin/", methods=['POST'])
def signin():
    session = UserSession()
    incoming_data = request.json
    print(incoming_data)

    try:
        if 'email' not in incoming_data or 'password' not in incoming_data:
            return jsonify({"error": "Email and password are required."}), 400

        email = incoming_data['email']
        password = incoming_data['password']

        user = session.query(User).filter_by(email=email).first()

        if user is None:
            return jsonify({"error": "User not found."}), 404

        if not check_passwords( password,user.password):
            return jsonify({"error": "Incorrect password."}), 401

        return jsonify({"id": user.id,'userName':user.name, 'email': user.email, 'phoneNumber': user.email}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        session.close()


@app.route("/get_trips/", methods=['GET'])
def get_trips():
    print(request.args)
    from_city = request.args.get('from_city')
    to_city = request.args.get('to_city')
    date_str = request.args.get('date')
    date = datetime.fromisoformat(date_str)
    if not from_city or not to_city or not date_str:
        return jsonify({"error": "Missing parameters. Please provide from_city, to_city, and date."}), 400

    try:

        session = TrainsSession()
        matching_rides = session.query(Ride).filter(
            Ride.from_station == from_city,
            Ride.to_station == to_city,
            Ride.num_booked < Ride.capacity,
            extract('year', Ride.begin_time) == date.year,
            extract('month', Ride.begin_time) == date.month,
            extract('day', Ride.begin_time) == date.day
        ).all()

        trip_list = []
        for ride in matching_rides:
            trip = {
                "from_station": ride.from_station,
                "to_station": ride.to_station,
                "train_name": ride.train_name,
                "begin_time": ride.begin_time.strftime("%Y-%m-%d %H:%M:%S"),
                "end_time": ride.end_time.strftime("%Y-%m-%d %H:%M:%S"),
                "price": ride.price,
                "class_": ride.class_,
                "available_seats": int(ride.capacity)-int(ride.num_booked),
            }
            trip_list.append(trip)

        return jsonify({"trips": trip_list}), 200

    except ValueError:
        return jsonify({"error": "Invalid date format. Please use YYYY-MM-DD."}), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        session.close()

@app.route('/book/', methods=['POST'])
def book_trip ():
    data = request.json
    print(type(data['begin_time']))
    data['begin_time']=datetime.fromisoformat(data['begin_time'])
    data['end_time']=datetime.fromisoformat(data['end_time'])

    session = TrainsSession()
    trip = session.query(Ride).filter(
        Ride.from_station==data['from_station'],
        Ride.to_station==data['to_station'],
        Ride.train_name == data['train_name'],
        Ride.begin_time == data['begin_time'],
        Ride.class_ == data['class_'],
        # may add more if needed;
        ).first()
    print(trip)

    if not trip:
        return jsonify({"error": "Trip not found"}), 404

    if trip.capacity-trip.num_booked <= 0:
        return jsonify({"error": "No available seats"}), 400
    trip.num_booked -= 1
    session.commit()
    session.refresh(trip)

    session =TicketsSession()
    db_ticket = Ticket(**data)
    session.add(db_ticket)
    session.commit()
    session.refresh(db_ticket)

    book_ticket(from_station= data['from_station'], to_station= data['to_station'], train_name=data['train_name'],
                train_class=data['class_'], date=data['begin_time'], price=data['price'], ticket_id=db_ticket.ticket_id)

    image_path = f'the-tickets/ticket_{db_ticket.ticket_id}.png'
    with open(image_path, 'rb') as f:
        im_b64 = base64.b64encode(f.read())
        image_bytes = im_b64.decode('utf-8')
        data = {
            'image': image_bytes,
            'imageID': str(db_ticket.ticket_id),
            'expiryDate':(data['end_time']+timedelta(hours=2)).isoformat()
        }
        print()
        return jsonify(data), 200


@app.route("/verify_email/", methods=['POST'])
def verify_email():
    data = request.json
    email = data['email']
    token = send_verification_email(email)
    return jsonify({'token':str(token),
                    'canEmail':email}), 200


@app.route("/update_email/", methods=['POST'])
def update_email():
    data = request.json
    email = data['email']
    id = data['id']
    session = UserSession()
    user = session.query(User).filter_by(id=id).first()
    if user is not None:
        user.email=email
        session.commit()
        session.refresh(user)
        return jsonify({'message':'updated successfully'}),200
    return jsonify({'message':'user does not exist'}),404


@app.route("/update_phone_number/", methods=['POST'])
def update_phone_number():
    data = request.json
    phone_number = data['phoneNumber']
    id = data['id']
    session = UserSession()
    user = session.query(User).filter_by(id=id).first()
    if user is not None:
        user.phone_number = phone_number
        session.commit()
        session.refresh(user)
        return jsonify({'message': 'updated successfully'}), 200
    return jsonify({'message': 'user does not exist'}), 404


if __name__ == "__main__":
    session = TrainsSession()

    try:
        session.add_all(rides_to_insert)
        session.commit()
        print("Successfully inserted rides.")

    except Exception as e:
        session.rollback()
        print("Error:", str(e))

    finally:
        session.close()
    app.run(debug=True)
