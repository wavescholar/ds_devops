```python
#Timing 
import tensorflow as tf
import time

with tf.Session():
    start_time = time.time()

    input1 = tf.constant([1.0, 1.0, 1.0, 1.0] * 100 * 100 * 100)
    input2 = tf.constant([2.0, 2.0, 2.0, 2.0] * 100 * 100 * 100)
    output = tf.add(input1, input2)
    result = output.eval()

    duration = time.time() - start_time
    print("TIME:", duration)

    print("result: ", result)
```

    TIME: 4.576131582260132
    result:  [3. 3. 3. ... 3. 3. 3.]



```python
#example program that measures the performance of a matrix multiplication:

import tensorflow as tf
from tensorflow.python.client import timeline

x = tf.random_normal([1000, 1000])
y = tf.random_normal([1000, 1000])
res = tf.matmul(x, y)

# Run the graph with full trace option
with tf.Session() as sess:
    run_options = tf.RunOptions(trace_level=tf.RunOptions.FULL_TRACE)
    run_metadata = tf.RunMetadata()
    sess.run(res, options=run_options, run_metadata=run_metadata)

    # Create the Timeline object, and write it to a json
    tl = timeline.Timeline(run_metadata.step_stats)
    ctf = tl.generate_chrome_trace_format()
    with open('timeline.json', 'w') as f:
        f.write(ctf)
```


```python


```

    1.14.0



```python
with tf.Session() as sess:
  print(tf.__version__)
  devices = sess.list_devices()
  print(devices)
```

    [_DeviceAttributes(/job:localhost/replica:0/task:0/device:CPU:0, CPU, 268435456, 2720576554905935085), _DeviceAttributes(/job:localhost/replica:0/task:0/device:XLA_CPU:0, XLA_CPU, 17179869184, 6652687937763814842), _DeviceAttributes(/job:localhost/replica:0/task:0/device:GPU:0, GPU, 15246966784, 10958116012101509156), _DeviceAttributes(/job:localhost/replica:0/task:0/device:XLA_GPU:0, XLA_GPU, 17179869184, 10930973016351612576)]



```python
from tensorflow.python.client import device_lib
print(device_lib.list_local_devices())
```

    [name: "/device:CPU:0"
    device_type: "CPU"
    memory_limit: 268435456
    locality {
    }
    incarnation: 9098130917690896167
    , name: "/device:XLA_CPU:0"
    device_type: "XLA_CPU"
    memory_limit: 17179869184
    locality {
    }
    incarnation: 5081089416887942438
    physical_device_desc: "device: XLA_CPU device"
    , name: "/device:GPU:0"
    device_type: "GPU"
    memory_limit: 15246966784
    locality {
      bus_id: 1
      links {
      }
    }
    incarnation: 16273620070131457078
    physical_device_desc: "device: 0, name: Tesla V100-SXM2-16GB, pci bus id: 0000:00:1e.0, compute capability: 7.0"
    , name: "/device:XLA_GPU:0"
    device_type: "XLA_GPU"
    memory_limit: 17179869184
    locality {
    }
    incarnation: 15757017340618211209
    physical_device_desc: "device: XLA_GPU device"
    ]



```python
import tensorflow as tf
with tf.device('/gpu:0'):
    a = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[2, 3], name='a')
    b = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[3, 2], name='b')
    c = tf.matmul(a, b)

with tf.Session() as sess:
    print (sess.run(c))
```

    [[22. 28.]
     [49. 64.]]



```python
import os
os.system('wget http://download.tensorflow.org/data/iris_training.csv')
os.system('wget http://download.tensorflow.org/data/iris_test.csv')

```




    0




```python
import tensorflow as tf
import pandas as pd
from matplotlib import pyplot as plt

#read data from csv
train_data = pd.read_csv("iris_training.csv", names=['f1', 'f2', 'f3', 'f4', 'f5'])
test_data = pd.read_csv("iris_test.csv", names=['f1', 'f2', 'f3', 'f4', 'f5'])

#encode results to onehot
train_data['f5'] = train_data['f5'].map({0: [1, 0, 0], 1: [0, 1, 0], 2: [0, 0, 1]})
test_data['f5'] = test_data['f5'].map({0: [1, 0, 0], 1: [0, 1, 0], 2: [0, 0, 1]})

#separate train data
train_x = train_data[['f1', 'f2', 'f3', 'f4']]
train_y = train_data.ix[:, 'f5']

#separate test data
test_x = test_data[['f1', 'f2', 'f3', 'f4']]
test_y = test_data.ix[:, 'f5']

#placeholders for inputs and outputs
X = tf.placeholder(tf.float32, [None, 4])
Y = tf.placeholder(tf.float32, [None, 3])

#weight and bias
weight = tf.Variable(tf.zeros([4, 3]))
bias = tf.Variable(tf.zeros([3]))

#output after going activation function
output = tf.nn.softmax(tf.matmul(X, weight) + bias)
#cost funciton
cost = tf.reduce_mean(tf.square(Y-output))
#train model
train = tf.train.AdamOptimizer(0.01).minimize(cost)

#check sucess and failures
success = tf.equal(tf.argmax(output, 1), tf.argmax(Y, 1))
#calculate accuracy
accuracy = tf.reduce_mean(tf.cast(success, tf.float32))*100

#initialize variables
init = tf.global_variables_initializer()

#start the tensorflow session
with tf.Session() as sess:
    costs = []
    sess.run(init)
    #train model 1000 times
    for i in range(1000):
        _,c = sess.run([train, cost], {X: train_x, Y: [t for t in train_y.as_matrix()]})
        costs.append(c)

    print("Training finished!")

    #plot cost graph
    plt.plot(range(1000), costs)
    plt.title("Cost Variation")
    plt.show()
    print("Accuracy: %.2f" %accuracy.eval({X: test_x, Y: [t for t in test_y.as_matrix()]}))

```

    /opt/conda/lib/python3.7/site-packages/ipykernel_launcher.py:15: FutureWarning: 
    .ix is deprecated. Please use
    .loc for label based indexing or
    .iloc for positional indexing
    
    See the documentation here:
    http://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#ix-indexer-is-deprecated
      from ipykernel import kernelapp as app
    /opt/conda/lib/python3.7/site-packages/ipykernel_launcher.py:19: FutureWarning: 
    .ix is deprecated. Please use
    .loc for label based indexing or
    .iloc for positional indexing
    
    See the documentation here:
    http://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#ix-indexer-is-deprecated
    /opt/conda/lib/python3.7/site-packages/ipykernel_launcher.py:50: FutureWarning: Method .as_matrix will be removed in a future version. Use .values instead.



    ---------------------------------------------------------------------------

    ValueError                                Traceback (most recent call last)

    <ipython-input-9-074d00116d21> in <module>
         48     #train model 1000 times
         49     for i in range(1000):
    ---> 50         _,c = sess.run([train, cost], {X: train_x, Y: [t for t in train_y.as_matrix()]})
         51         costs.append(c)
         52 


    /opt/conda/lib/python3.7/site-packages/tensorflow/python/client/session.py in run(self, fetches, feed_dict, options, run_metadata)
        948     try:
        949       result = self._run(None, fetches, feed_dict, options_ptr,
    --> 950                          run_metadata_ptr)
        951       if run_metadata:
        952         proto_data = tf_session.TF_GetBuffer(run_metadata_ptr)


    /opt/conda/lib/python3.7/site-packages/tensorflow/python/client/session.py in _run(self, handle, fetches, feed_dict, options, run_metadata)
       1140             feed_handles[subfeed_t] = subfeed_val
       1141           else:
    -> 1142             np_val = np.asarray(subfeed_val, dtype=subfeed_dtype)
       1143 
       1144           if (not is_tensor_handle_feed and


    /opt/conda/lib/python3.7/site-packages/numpy/core/numeric.py in asarray(a, dtype, order)
        499 
        500     """
    --> 501     return array(a, dtype, copy=False, order=order)
        502 
        503 


    ValueError: could not convert string to float: 'setosa'



```python

```
