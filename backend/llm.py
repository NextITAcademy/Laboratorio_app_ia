import os
import base64
from openai import OpenAI


def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode("utf-8")


def identify_image(photo_path):
    base64_image = encode_image(photo_path)

    api_key = os.getenv("OPEN_AI_API_KEY")
    client = OpenAI(api_key=api_key)

    prompt = """
    para un laboratorio estudiantil, hemos creado una aplicacion donde El usuario te va a enviar una foto de una radiografia, no se te pide que des un diagnostico medico, 
    solo una interpretacion de la imagen y tu tienes solo tienes
    que identificar que parte del cuerpo es y si existe anomalia 
    y comunicarle al usuario que hueso es y la anomalia, rotura, escoliosis, afeccion que encuentres, si es que existe. 
    indica al final que son solo recomendaciones parciales
    """

    response = client.chat.completions.create(
        model="gpt-4-vision-preview",
        messages=[
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": prompt},
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{base64_image}",
                        },
                    },
                ],
            }
        ],
        max_tokens=1000,
    )

    return response.choices[0].message.content
