import numpy as np
from PIL import Image
import tensorflow as tf

interpreter = tf.lite.Interpreter('assets/garbagelite.tflite')
interpreter.allocate_tensors()
# array([  1, 224, 224,   3], dtype=int32)
input_details = interpreter.get_input_details()
# array([1, 6], dtype=int32)
output_details = interpreter.get_output_details()

imgs = [
    'bin/images/cardboard/cardboard309.jpg',
    'bin/images/glass/glass373.jpg',
    'bin/images/metal/metal369.jpg',
    'bin/images/paper/paper544.jpg',
    'bin/images/plastic/plastic464.jpg',
    'bin/images/trash/trash132.jpg'
]


def tflitePredict(input_data):
    interpreter.set_tensor(input_details[0]['index'], input_data)
    interpreter.invoke()
    return interpreter.get_tensor(output_details[0]['index'])


def predict(imgPath):
    im = Image.open(imgPath).resize((224, 224))
    im = np.array(im, dtype=np.float32)
    data = im.reshape(-1, 224, 224, 3)
    # 模型预测结果
    prediction = tflitePredict(data)[0].tolist()
    maxIdx = prediction.index(max(prediction))
    print(f'{imgPath}\t\t-->\t\t{maxIdx}')


for img in imgs:
    predict(img)
