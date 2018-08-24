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


class HEMessage(Parameter) :
    """ HEMessage is composed of:
        - a name (string),
        - a type ("int" / "poly" / "matrix" / "matrixPoly" / "float" / "list" / "listPoly"),
        - dimensions (rows * cols),
        - a value
        - a group ( "plain" / "cipher")
        - a depth (integer)
        - a degree (integer > 0 for polynomials / 0 for integers)"""

    def __init__(self, name = "", value = 0, rows = 0, cols = 0, type = "NoType", group = "plain", depth = 0, degree = 0, aftermult = 0) :
        if isinstance(name, Parameter) :
            value =  name.value
            rows = name.rows
            cols = name.cols
            type = name.type
            degree = name.degree
            name = name.name
        Parameter.__init__(self, name, value, rows, cols, type, degree)
        self.__group = group
        self.__depth = depth
        self.__aftermult = 0

    @property
    def group(self) :
        return self.__group

    @group.setter
    def group(self, group) :
        self.__group = group

    @property
    def aftermult(self) :
        return self.__aftermult

    @aftermult.setter
    def aftermult(self, aftermult) :
        self.__aftermult = aftermult

    @property
    def depth(self) :
        return self.__depth

    @depth.setter
    def depth(self, depth) :
        if self.group != "plain" :
            self.__depth = depth
        else :
            raise Exception("HEMessage: Impossible to modify plaintext depth in {}".format(depth))

    def __repr__(self):
        return "HEMessage: name({}), value({}), type({}, {}), dimensions({}x{}), depth({}), degree({})".format(
                self.name, self.value, self.group, self.type, self.rows, self.cols, self.depth, self.degree)
