import cv2
import sys
import os

def detect_faces(image_path):
    image = cv2.imread(image_path)
    if image is None:
        print("Не удалось загрузить изображение.")
        return

    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

    faces = face_cascade.detectMultiScale(gray, 1.1, 4)

    if len(faces) == 0:
        print("Лица не найдены.")
    else:
        print(f"Найдено {len(faces)} лиц(а):")
        for (x, y, w, h) in faces:
            print(f"Лицо: x={x}, y={y}, ширина={w}, высота={h}")

if __name__ == "__main__":
    script_dir = os.path.dirname(os.path.abspath(__file__))

    if len(sys.argv) > 1:
        image_path = sys.argv[1]
        print(f"Используемое изображение: {image_path}")
    else:
        image_path = os.path.join(script_dir, 'img.png')
        print(f"Аргумент не передан, изображение по умолчанию: {image_path}")

    detect_faces(image_path)