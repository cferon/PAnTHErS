#
# (C) Copyright 2018 - Cyrielle FERON / ENSTA Bretagne.
# Contributor(s) : Cyrielle FERON <cyrielle.feron@ensta-bretagne.org> (2018)
#
#
# This software is governed by the CeCILL 2.1 license under French law and
# abiding by the rules of distribution of free software.  You can  use,
# modify and/ or redistribute the software under the terms of the CeCILL 2.1
# license as circulated by CEA, CNRS and INRIA at the following URL
# "http://www.cecill.info".
#
# As a counterpart to the access to the source code and  rights to copy,
# modify and redistribute granted by the license, users are provided only
# with a limited warranty  and the software's author,  the holder of the
# economic rights,  and the successive licensors  have only  limited
# liability.
#
# In this respect, the user's attention is drawn to the risks associated
# with loading,  using,  modifying and/or developing or reproducing the
# software by the user in light of its specific status of free software,
# that may mean  that it is complicated to manipulate,  and  that  also
# therefore means  that it is reserved for developers  and  experienced
# professionals having in-depth computer knowledge. Users are therefore
# encouraged to load and test the software's suitability as regards their
# requirements in conditions enabling the security of their systems and/or
# data to be ensured and,  more generally, to use and operate it in the
# same conditions as regards security.
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL 2.1 license and that you accept its terms.
#
#


class Parameter(object):
    """ Parameter object has :
        - a name (string),
        - a type ("int" / "poly" / "matrix" / "matrixPoly" / "float" / "list" / "listPoly"),
        - dimensions (rows * cols),
        - a value value
        - a degree (integer > 0 for polynomials / 0 for integers)"""

    def __init__(self, name = "", value = 0, rows = 0, cols = 0, type = "NoType", degree = 0):
        self.__name = name
        self.__value = value
        self.__rows = rows
        self.__cols = cols
        self.__type = type
        self.__degree = degree

    @property
    def name(self) :
        return self.__name

    @name.setter
    def name(self, name) :
        self.__name = name

    @property
    def value(self) :
        return self.__value

    @value.setter
    def value(self, value) :
        self.__value = value

    @property
    def rows(self) :
        return self.__rows

    @rows.setter
    def rows(self, rows) :
        if type(rows) == Parameter :
            self.__rows = rows.value
        else :
            self.__rows = rows

    @property
    def cols(self) :
        return self.__cols

    @cols.setter
    def cols(self, cols) :
        if type(cols) == Parameter :
            self.__cols = cols.value
        else :
            self.__cols = cols

    @property
    def type(self) :
        return self.__type

    @type.setter
    def type(self, type) :
        if self.__type == "NoType" or self.__type == type :
            self.__type = type
        elif self.__type == "matrix" and self.__cols == 1 and self.__rows == 1 and type == "int" :
            self.__type = type
        elif self.__type == "matrixPoly" and self.__cols == 1 and self.__rows == 1 and type == "poly" :
            self.__type = type
        elif (type == "int" or type == "float") and (self.__type == "int" or self.__type == "float") :
            self.__type = type
        elif (type == "matrix" or type == "matrixPoly") and (self.__type == "matrix" or self.__type == "matrixPoly") :
            self.__type = type
        else :
            raise Exception("Parameter: Impossible to modify type {} of Parameter {} in {}".format(self.__type, self.name, type))

    @property
    def degree(self) :
        return self.__degree

    @degree.setter
    def degree(self, degree) :
        self.__degree = degree


    def __repr__(self):
        return "Parameter: name({}), value({}), type({}), dimensions({}x{}), degree({})".format(
                self.name, self.value, self.type, self.rows, self.cols, self.degree)

    def __eq__(self, param):
        if self.name == param.name and (self.type == param.type  or \
            (self.type == "matrix" and self.cols == 1 and self.type == 1 and param.name == "int") or \
            (self.type == "matrixPoly" and self.cols == 1 and self.type == 1 and param.name == "poly") or \
            ((param.name == "int" or param.name == "float") and (self.type == "int" or self.type == "float")) or \
            ((param.name == "matrix" or param.name == "matrixPoly") and (self.type == "matrix" or self.type == "matrixPoly"))) :
            return True
        else :
            return False

    def __ne__(self, param):
        if self.name == param.name and (self.type == param.type  or \
            (self.type == "matrix" and self.cols == 1 and self.type == 1 and param.name == "int") or \
            (self.type == "matrixPoly" and self.cols == 1 and self.type == 1 and param.name == "poly") or \
            ((param.name == "int" or param.name == "float") and (self.type == "int" or self.type == "float")) or \
            ((param.name == "matrix" or param.name == "matrixPoly") and (self.type == "matrix" or self.type == "matrixPoly"))) :
            return False
        else :
            return True

    def __str__(self):
        return "Parameter: name({}), value({}), type({}), dimensions({}x{}), degree({})".format(
                self.name, self.value, self.type, self.rows, self.cols, self.degree)

    def __getitem__(self,i):
        if self.type == "int" or self.type == "float" :
            return self.value
        else :
            return self.value[i]

    def __setitem__(self,i,value):
        self.value[i] = value

    def __add__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        add = atomicfunctioncreator.make_add()
        return add.ope([self, inParam])[0]

    def __mul__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        mult = atomicfunctioncreator.make_mult()
        return mult.ope([self, inParam])[0]

    def __div__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        div = atomicfunctioncreator.make_div()
        return div.ope([self, inParam])[0]

    def __floordiv__(self, inParam) :
        val1 = self.value
        val2 = inParam.value
        builder = Builder()
        return builder.parameter("floordiv", "int", val1//val2,1,1)

    def __mod__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        mod = atomicfunctioncreator.make_mod()
        return mod.ope([self, inParam])[0]

    def __pow__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        pow = atomicfunctioncreator.make_pow()
        return pow.ope([self, inParam])[0]

    def __sub__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        sub = atomicfunctioncreator.make_sub()
        return sub.ope([self, inParam])[0]

    def __radd__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        add = atomicfunctioncreator.make_add()
        return add.ope([inParam, self])[0]

    def __rmul__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        mult = atomicfunctioncreator.make_mult()
        return mult.ope([inParam, self])[0]

    def __rdiv__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        div = atomicfunctioncreator.make_div()
        return div.ope([inParam, self])[0]

    def __rmod__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        mod = atomicfunctioncreator.make_mod()
        return mod.ope([inParam, self])[0]

    def __rpow__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        pow = atomicfunctioncreator.make_pow()
        return pow.ope([inParam, self])[0]

    def __rsub__(self, inParam) :
        atomicfunctioncreator = AtomicFunctionCreator()
        sub = atomicfunctioncreator.make_sub()
        return sub.ope([inParam, self])[0]
