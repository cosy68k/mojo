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

from python import PythonObject
from python.python import _get_global_python_itf
from python._cpython import PyObjectPtr


trait PyObjectBase:
    pass


struct PyDict(PyObjectBase):
    """A python object of subtype PyDict."""

    var python_object: PythonObject

    fn __init__(inout self):
        var cpython = _get_global_python_itf().cpython()
        self.python_object = cpython.PyDict_New()

    fn __init__(inout self, ptr: PyObjectPtr) raises:
        var cpython = _get_global_python_itf().cpython()
        if not cpython.PyDict_Check(ptr):
            raise Error("PyDict.__init__ error: PyDict_Check failed")
        self.python_object = ptr

    fn __setitem__(inout self, key: PythonObject, value: PythonObject) raises:
        var cpython = _get_global_python_itf().cpython()
        var result = cpython.PyDict_SetItem(self.python_object.py_object, key.py_object, value.py_object)
        if result != 0:
            raise Error("PyDict.__setitem__ error: PyDict_SetItem failed")

    fn __len__(self) -> Int:
        var cpython = _get_global_python_itf().cpython()
        return cpython.PyDict_Size(self.python_object.py_object)

    fn __getitem__(self, key: PythonObject) raises -> PythonObject:
        var cpython = _get_global_python_itf().cpython()
        var result: PyObjectPtr = cpython.PyDict_GetItemWithError(self.python_object.py_object, key.py_object)
        cpython.Py_IncRef(result)
        return result

    fn __delitem__(inout self, key: PythonObject) raises:
        var cpython = _get_global_python_itf().cpython()
        var result: Int = cpython.PyDict_DelItem(self.python_object.py_object, key.py_object)
        if result != 0:
            raise Error("PyDict.__delitem__ error: PyDict_DelItem failed")

    fn __contains__(self, key: PythonObject) raises -> Bool:
        var cpython = _get_global_python_itf().cpython()
        var result: Int = cpython.PyDict_Contains(self.python_object.py_object, key.py_object)
        if result == -1:
            raise Error("PyDict.__contains__ error: PyDict_Contains failed")
        return result

    fn clear(inout self):
        var cpython = _get_global_python_itf().cpython()
        cpython.PyDict_Clear(self.python_object.py_object)

    fn copy(self) raises -> PyDict:
        var cpython = _get_global_python_itf().cpython()
        return cpython.PyDict_Copy(self.python_object.py_object)

    fn items(self) -> PythonObject:
        var cpython = _get_global_python_itf().cpython()
        return cpython.PyDict_Items(self.python_object.py_object)

    fn keys(self) -> PythonObject:
        var cpython = _get_global_python_itf().cpython()
        return cpython.PyDict_Keys(self.python_object.py_object)

    fn values(self) -> PythonObject:
        var cpython = _get_global_python_itf().cpython()
        return cpython.PyDict_Values(self.python_object.py_object)
