import qrcode
from PIL import Image, ImageDraw, ImageFont
import numpy as np


# Function to generate a QR code
def generate_qr_code(data):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)
    qr_image = qr.make_image(fill_color="black", back_color="white")
    pil_image = Image.fromarray(np.array(qr_image))
    return pil_image

# Function to create a ticket image
def create_ticket(from_station, to_station,train_name, train_class, date,price,ticket_id):
    qr_code_size = 15
    text_indent = 10

    qr_code = generate_qr_code(f"""From: {from_station}\nTo: {to_station}\nClass: {train_class}\n
                               Date: {date}\n train_name:{train_name}\nprice: {price}\nid\n{ticket_id}""")

    qr_code=qr_code.resize(size=(130,130))


    ticket_width = 150
    ticket_height = 200

    ticket_image = Image.new("RGB", (ticket_width, ticket_height), "white")

    back_im = ticket_image.copy()
    back_im.paste(qr_code, (10,10))


    draw = ImageDraw.Draw(back_im)
    font = ImageFont.load_default()

    color='green'
    start_line= 10
    draw.text((55,5),"Qetarak",fill='blue',font = font)
    draw.text((start_line,135), f"From: {from_station}", fill=color, font=font,antialias=True)
    draw.text((start_line,145), f"To: {to_station}", fill=color, font=font)
    draw.text((start_line, 155), f"train name: {train_name}", fill=color, font=font)
    draw.text((start_line, 165), f"Class: {train_class}", fill=color, font=font)
    draw.text((start_line, 175), f"Date: {date}", fill=color, font=font)
    draw.text((start_line,185),f"price:{price}",fill=color,font=font)


    return back_im

# Main function for booking a ride ticket
def book_ticket(from_station,to_station,train_name,train_class,date,price,ticket_id):

    ticket = create_ticket(from_station, to_station,train_name, train_class, date,price,ticket_id)
    ticket.save(f"the-tickets/ticket_{ticket_id}.png")

# Entry point of the script
