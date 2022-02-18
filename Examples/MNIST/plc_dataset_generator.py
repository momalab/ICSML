import os
import tensorflow as tf
import tensorflow_datasets as tfds

# from tensorflow import keras
# model = keras.models.load_model('dense-256-512-256.h5')

# Create dataset directory
if not os.path.exists('plc_mnist'):
    os.makedirs('plc_mnist')

# Load Dataset
(ds_train, ds_test), ds_info = tfds.load(
    'mnist',
    # split=['train', 'test'],
    split=['train', 'test[:100]'],
    shuffle_files=True,
    as_supervised=True,
    with_info=True,
)

# Preprocessing and Input pipeline settings
def normalize_img(image, label):
  """Normalizes images: `uint8` -> `float32`."""
  return tf.cast(image, tf.float32) / 255., label

def np_flatten_img(image, label):
    """Flattens image"""
    return tf.reshape(image, [1, 784]), label

ds_test = ds_test.map(
    normalize_img, num_parallel_calls=tf.data.AUTOTUNE)
ds_test = ds_test.map(
    np_flatten_img, num_parallel_calls=tf.data.AUTOTUNE)
#ds_test = ds_test.batch(128)
ds_test = ds_test.cache()
ds_test = ds_test.prefetch(tf.data.AUTOTUNE)

# Iterate through images, saving as binary files of float64 numbers
for index, sample in enumerate(ds_test.as_numpy_iterator()):
    image = sample[0].astype('float64')
    label = sample[1].astype('float64')
    # Save to binary files
    image.tofile(f"plc_mnist/{index}_img.bin")
    label.tofile(f"plc_mnist/{index}_label.bin")

    # prediction = model.predict(image)
    # print(f"Label of {index}: {label}. Prediction: {prediction}")
    print(f"Label of {index}: {label}")
