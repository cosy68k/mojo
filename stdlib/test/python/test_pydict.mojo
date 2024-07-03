# ===----------------------------------------------------------------------=== #
# Copyright (c) 2024, Modular Inc. All rights reserved.
#
# Licensed under the Apache License v2.0 with LLVM Exceptions:
# https://llvm.org/LICENSE.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===----------------------------------------------------------------------=== #
# XFAIL: asan && !system-darwin
# RUN: %mojo %s

from python import Python, PythonObject, PyDict
from python.python import _get_global_python_itf
from testing import assert_equal, assert_false, assert_true, assert_raises


fn test_init() raises:
    var cpython = _get_global_python_itf().cpython()
    var d: PyDict = PyDict()
    var r: Bool = cpython.PyDict_Check(d.python_object.py_object)
    assert_true(r)

    var wrong_type: PythonObject = cpython.toPython(11)
    with assert_raises():
        var unused: PyDict = wrong_type.py_object


fn test_len() raises:
    var cpython = _get_global_python_itf().cpython()
    var d: PyDict = PyDict()
    assert_equal(len(d), 0)


fn test_setitem() raises:
    var cpython = _get_global_python_itf().cpython()
    var d: PyDict = PyDict()

    var k1: PythonObject = cpython.toPython(11)
    var v1: PythonObject = cpython.toPython(22)
    d[k1] = v1
    assert_equal(len(d), 1)


fn test_getitem() raises:
    var cpython = _get_global_python_itf().cpython()
    var d: PyDict = PyDict()
    d[111] = 222
    var r = d[111]
    assert_equal(r, 222)


fn test_delitem() raises:
    var cpython = _get_global_python_itf().cpython()
    var d: PyDict = PyDict()
    d[111] = 222

    d.__delitem__(111)

    var missing_key: Int = 999
    with assert_raises():
        d.__delitem__(missing_key)


fn test_contains() raises:
    var cpython = _get_global_python_itf().cpython()
    var d: PyDict = PyDict()
    d[111] = 222

    assert_true(111 in d)

    var missing_key: Int = 999
    assert_false(missing_key in d)

    var invalid_key: PythonObject = cpython.PyList_New(0)
    with assert_raises():
        var r: Bool = invalid_key.py_object in d


fn test_copy() raises:
    var cpython = _get_global_python_itf().cpython()
    var d: PyDict = PyDict()
    d[111] = 222

    var c: PyDict = d.copy()
    assert_equal(len(c), 1)


fn test_clear() raises:
    var cpython = _get_global_python_itf().cpython()
    var d: PyDict = PyDict()
    d[111] = 222

    assert_equal(len(d), 1)
    d.clear()
    assert_equal(len(d), 0)


fn test_items() raises:
    var cpython = _get_global_python_itf().cpython()
    var d: PyDict = PyDict()

    var r1: PythonObject = d.items()
    assert_equal(len(r1), 0)

    d[111] = 222

    var r2: PythonObject = d.items()
    assert_equal(len(r2), 1)


fn test_keys() raises:
    var cpython = _get_global_python_itf().cpython()
    var d: PyDict = PyDict()

    var r1: PythonObject = d.keys()
    assert_equal(len(r1), 0)

    d[111] = 222

    var r2: PythonObject = d.keys()
    assert_equal(len(r2), 1)


fn test_values() raises:
    var cpython = _get_global_python_itf().cpython()
    var d: PyDict = PyDict()

    var r1: PythonObject = d.values()
    assert_equal(len(r1), 0)

    d[111] = 222

    var r2: PythonObject = d.values()
    assert_equal(len(r2), 1)


def main():
    # initializing Python instance calls init_python
    var python = Python()

    test_init()
    test_len()
    test_setitem()
    test_getitem()
    test_delitem()
    test_contains()
    test_copy()
    test_clear()
    test_items()
    test_keys()
    test_values()
