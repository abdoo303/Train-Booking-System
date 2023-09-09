from datetime import datetime
import bcrypt

def hash_password(password):
    password= password.encode()
    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(password, salt)
    return hashed_password



def check_passwords(candidate,actual_password):
    return bcrypt.checkpw(candidate.encode(), actual_password)

governorates_dict = {
    "01": "Cairo",
    "02": "Alexandria",
    "03": "Port Said",
    "04": "Suez",
    "11": "Damietta",
    "12": "Dakahlia",
    "13": "Sharqia",
    "14": "Qalyubia",
    "15": "Kafr El-Sheikh",
    "16": "Gharbia",
    "17": "Monufia",
    "18": "Beheira",
    "19": "Ismailia",
    "21": "Giza",
    "22": "Beni Suef",
    "23": "Fayoum",
    "24": "Minya",
    "25": "Asyut",
    "26": "Sohag",
    "27": "Qena",
    "28": "Aswan",
    "29": "Luxor",
    "31": "Red Sea",
    "32": "New Valley",
    "33": "Matruh",
    "34": "North Sinai",
    "35": "South Sinai",
    "88": "Foreigners"
}

egyptian_train_stations = [
    "Cairo",
    "Alexandria",
    "Giza",
    "Asyut",
    "Mansoura",
    "Minya",
    "Zagazig",
    "Luxor",
    "Assiut",
    "Tanta",
    "Benha",
    "Sohag",
    "Ismailia",
    "Fayoum",
    "Suez",
    "Damietta",
    "Qena",
    "Port Said",
    "Aswan",
    "Damanhur",
    "Shibin El Kom",
    "Kafr El Sheikh",
    "New Valley",
    "Banha",
    "Desouk",
    "Rosetta",
    "Abu Hammad",
    "El Mansoura",
    "El Mahalla El Kubra",
    "Mallawi",
    "Marsa Matruh",
    "Kafr El Dawwar",
    "Sidi Gaber",
    "Mit Ghamr",
    "Beni Suef",
    "Akhmim",
    "El Sadat",
    "Talkha",
    "Sidi Salim",
    "El Hammam",
    "El Edwa",
    "Ain Shams",
    "Girga",
    "El Mahata",
    "Malka",
    "Samalut",
    "Quesna",
    "Deirut",
]


def getGovernrate(code:str):
    return governorates_dict.get(code,"Wrong")


def processIdNumber(id:str):
    year=1700+int(id[0])*100
    year+=int(id[1:3])
    month= int(id[3:5])
    day=int(id[5:7])
    dob=datetime(year=year,month=month,day=day)

    govern=getGovernrate(id[7:9])

    is_male=int(id[12])%2==1

    return {"dob":dob,
            "govern":govern,
            "gender":'male' if is_male else 'female'
            }




def processIncomingData(data):
    subData = processIdNumber(data['nationalID'])
    return {
        'name':data['name'],
        'email':data['email'],
        'national_id': data['nationalID'],
        'dob':subData['dob'],
        "govern": subData['govern'],
        'gender': subData['gender'],
        "phone_number": data['phoneNumber'],
        'password': hash_password(data['password'])


    }


