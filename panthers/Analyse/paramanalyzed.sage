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


class ParamAnalyzed(object) :
    """ Class representing a set of parameter with its theoretical and calibrated analyses (for a given scheme and application)."""

    def __init__(self, appli = -1, scheme = -1, params = [], compPanthers = 0, memPanthers = 0, compCalibrated = 0, memCalibrated = 0, depth = 0) :
        if isinstance(appli, ParamAnalyzed) :
            scheme = appli.scheme
            params = appli.params
            compPanthers = appli.compPanthers
            memPanthers = appli.memPanthers
            compCalibrated = appli.compCalibrated
            memCalibrated = appli.memCalibrated
            depth = appli.depth
            appli = appli.appli
        if isinstance(appli, tuple) :
            depth = appli[0]
            params = appli[1]
            appli = -1
        self.__appli = appli
        self.__scheme = scheme
        self.__params = params
        self.__compPanthers = compPanthers
        self.__memPanthers = memPanthers
        self.__compCalibrated = compCalibrated
        self.__memCalibrated = memCalibrated
        self.__depth = depth

    @property
    def appli(self) :
        return self.__appli

    @appli.setter
    def appli(self, appli) :
        self.__appli = appli

    @property
    def scheme(self) :
        return self.__scheme

    @scheme.setter
    def scheme(self, scheme) :
        self.__scheme = scheme

    @property
    def params(self) :
        return self.__params

    @params.setter
    def params(self, params) :
        self.__params = params

    @property
    def compPanthers(self) :
        return self.__compPanthers

    @compPanthers.setter
    def compPanthers(self, compPanthers) :
        self.__compPanthers = compPanthers

    @property
    def memPanthers(self) :
        return self.__memPanthers

    @memPanthers.setter
    def memPanthers(self, memPanthers) :
        self.__memPanthers = memPanthers

    @property
    def compCalibrated(self) :
        return self.__compCalibrated

    @compCalibrated.setter
    def compCalibrated(self, compCalibrated) :
        self.__compCalibrated = compCalibrated

    @property
    def memCalibrated(self) :
        return self.__memCalibrated

    @memCalibrated.setter
    def memCalibrated(self, memCalibrated) :
        self.__memCalibrated = memCalibrated

    @property
    def depth(self) :
        return self.__depth

    @depth.setter
    def depth(self, depth) :
        self.__depth = depth

    def __str__(self) :
        res = "({}, [".format(self.depth)
        for i in range(len(self.params)) :
            res = res + str(self.params[i])
            if i != len(self.params) - 1 :
                res = res + ", "
        return res + "])"

    def __repr__(self) :
        res = "({}, [".format(self.depth)
        for i in range(len(self.params)) :
            res = res + str(self.params[i])
            if i != len(self.params) - 1 :
                res = res + ", "
        return res + "])"

    def __eq__(self, currentValue) :
        if self.appli == currentValue.appli and self.scheme == currentValue.scheme and self.params == currentValue.params :
            return True
        else :
            return False
