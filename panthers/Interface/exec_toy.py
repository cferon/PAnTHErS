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


from memory_profiler import profile
import sys
from sage.all_cmdline import *
from sage.all import *
from sage.rings.polynomial.polynomial_zmod_flint import Polynomial_zmod_flint

@profile
def executeAppliToyOnce() :
    infoFileName = "Tmp/executePracticalAnalysis_info.dat"
    infoFile = open(infoFileName, "r")
    infos = infoFile.read()
    infoFile.close()

    inputVariables = []
    scheme = int(infos[2])
    nbOfParamsIn = int(infos[0])
    paramsIn = []
    for i in range(nbOfParamsIn) :
        fileName = "Tmp/" + str(i) + ".dat"
        param = ParamVariation("")
        param.load(fileName)
        paramsIn = paramsIn + [param]

    progressBar = 0
    step = 0
    file = 0
    pointsList = 0

    param, sets = chooseParameter(scheme, paramsIn)
    schemeObject, mes = createSchemeWithPlaintextsAppliToy(scheme, param, sets, EXECUTION_ID)
    time1 = time.time()
    res = computeApplicationToy(schemeObject, mes, sets[0], progressBar, step)
    time2 = time.time()
    if file == 0 and pointsList == 0 :
        return time2-time1
    else :
        raise Exception("executeAppliToyOnce: file and pointsList must be both = 0.")


time = executeAppliToyOnce()
print("TimeExecuteAppliToyOnce: {}".format(time))
