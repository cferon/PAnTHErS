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


class Builder(object):
    """Class allowing to build :
        - Parameter
        - Key
        - HEMessage
        - AtomicFunction/Complexity/Memory
        - SpecificFunction/Complexity/Memory
        - HEKeyGen/Complexity/Memory
        - HEEnc/Complexity/Memory
        - HEDec/Complexity/Memory
        - HEAdd/Complexity/Memory
        - HEMult/Complexity/Memory """

    def __init__(self) :
        self

    def parameter(self, name, type = "NoType", value = 0, dim1 = 0, dim2 = 0, deg = 0):
        """ Parameter construction. Name obligatory."""

        if isinstance(dim1,Parameter) :
            dim1 = dim1.value

        if isinstance(dim2,Parameter) :
            dim2 = dim2.value

        if isinstance(deg,Parameter) :
            deg = deg.value

        if type == "list" and value == [] :
            value = [self.parameter("", "int", 0, 1, 1, 0) for i in range(dim2)]
        if type == "listMatrix" and value == [] :
            value = [[self.parameter("", "poly", 0, 1, 1, deg) for i in range(dim2)] for i in range(dim1)]

        param = Parameter(name, value, dim1, dim2, type, deg)

        return param

    def key(self, name, type = "NoType", value = 0, dim1 = 0, dim2 = 0, deg = 0):
        """ Key construction. Name obligatory."""

        if isinstance(dim1,Parameter) :
            dim1 = dim1.value

        if isinstance(dim2,Parameter) :
            dim2 = dim2.value

        if isinstance(deg,Parameter) :
            deg = deg.value

        if type == "list" and value == [] :
            value = [self.key(name, "int", 0, 1, 1, 0) for i in range(dim2)]
        if type == "listMatrix" and value == [] :
            value = [[self.key(name, "poly", 0, 1, 1, deg) for i in range(dim2)] for i in range(dim1)]

        key = Key(name, value, dim1, dim2, type, deg)

        return key

    def message(self, name, group, type = "NoType", value = 0, dim1 = 0, dim2 = 0, depth = 0, deg = 0, aftermult = 0):
        """ HEMessage construction. Name and group obligatory."""

        if isinstance(dim1,HEMessage) :
            dim1 = dim1.value

        if isinstance(dim2,HEMessage) :
            dim2 = dim2.value

        if isinstance(deg,Parameter) :
            deg = deg.value

        if type == "list" and value == [] :
            value = [self.message("", group, "int", 0, 1, 1, depth, deg, aftermult) for i in range(dim2)]
        if type == "listMatrix" and value == [] :
            value = [[self.message("", group, "poly", 0, 1, 1, depth, deg, aftermult) for i in range(dim2)] for i in range(dim1)]

        message = HEMessage(name, value, dim1, dim2, type, group, depth, deg, aftermult)

        return message

    def atomicFunction(self, name, flag, file) :
        return AtomicFunction(name, flag = flag, file = file)

    def specificFunction(self, name, flag, file) :
        return SpecificFunction(name, flag = flag, file = file)

    def heKeyGen(self, flag, file) :
        return HEKeyGen(flag = flag, file = file)

    def heEnc(self, flag, file) :
        return HEEnc(flag = flag, file = file)

    def heDec(self, flag, file) :
        return HEDec(flag = flag, file = file)

    def heAdd(self, flag, file) :
        return HEAdd(flag = flag, file = file)

    def heMult(self, flag, file) :
        return HEMult(flag = flag, file = file)

    def atomicFunctionComplexity(self, name) :
        return AtomicFunctionComplexity(name)

    def specificFunctionComplexity(self, name) :
        return SpecificFunctionComplexity(name)

    def heKeyGenComplexity(self) :
        return HEKeyGenComplexity()

    def heEncComplexity(self) :
        return HEEncComplexity()

    def heDecComplexity(self) :
        return HEDecComplexity()

    def heAddComplexity(self) :
        return HEAddComplexity()

    def heMultComplexity(self) :
        return HEMultComplexity()

    def atomicFunctionMemory(self, name) :
        return AtomicFunctionMemory(name)

    def specificFunctionMemory(self, name) :
        return SpecificFunctionMemory(name)

    def heKeyGenMemory(self) :
        return HEKeyGenMemory()

    def heEncMemory(self) :
        return HEEncMemory()

    def heDecMemory(self) :
        return HEDecMemory()

    def heAddMemory(self) :
        return HEAddMemory()

    def heMultMemory(self) :
        return HEMultMemory()
