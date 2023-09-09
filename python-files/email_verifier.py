from email.message import  EmailMessage
import ssl
import smtplib
import string
import random
def generate_token(length=6):
    characters = string.digits
    return ''.join(random.choice(characters) for _ in range(length))

def send_verification_email(reciever):
    sender = "abdelrahiim303@gmail.com"
    password= "mjnqnwsfzmdyviki"
    #    mjnqnwsfzmdyviki

    subject = 'Verification Code'
    verification_code = generate_token()
    body = f"""
    Your verification code is {verification_code}
    """

    em= EmailMessage()
    em['from']=sender
    em['to']=reciever
    em['subject']= subject
    em.set_content(body)

    context = ssl.create_default_context()
    with smtplib.SMTP_SSL('smtp.gmail.com',465,context =context) as smtp:
        smtp.login(sender,password)
        smtp.sendmail(sender,reciever,em.as_string())
    return verification_code

reciever = "abdelrahimabdelazim303@gmail.com"

# code = send_verification_email(reciever)




