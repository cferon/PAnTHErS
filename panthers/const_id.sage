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


#SCHEMES
FV_ID = 0
YASHE_ID = 1
FNTRU_ID = 2

#APPLICATIONS
MEDICAL_ID = 1
TOY_ID = 2
FIVEHB_ID = 3
CROISSANT_ID = 4
MAX_APP_ID = 5

#APPLICATION NAMES
MEDICAL_APP_NAME = "Medical"
TOY_APP_NAME = "Toy"
FIVEHB_APP_NAME = "FiveHB"
CROISSANT_APP_NAME = "Croissant"

#ANALYSIS_MODES / EXPLORATION_MODES
ANALYZE_ID = 0
EXECUTION_ID = 1
COMPLEXITY_ANALYSIS_ID = 2
MEMORY_ANALYSIS_ID = 3
EXPLORATION_ID = 4
#INVALID MODE, only here to know the max mode value
MAX_MODE_ID = 5

EXPLO_TYPE_COMPLEXITY = 1
EXPLO_TYPE_MEMORY = 2
EXPLO_TYPE_TRADEOFF = 3

def getApplicationName(appli) :
    appliName = ""
    if isinstance(appli, str) :
        appli = eval(appli)
    if appli == MEDICAL_ID :
        appliName = MEDICAL_APP_NAME
    elif appli == TOY_ID :
        appliName = TOY_APP_NAME
    elif appli == FIVEHB_ID :
        appliName = FIVEHB_APP_NAME
    elif appli == CROISSANT_ID :
        appliName = CROISSANT_APP_NAME
    else :
        raise Exception("getApplicationName: appli of ID {} is not in PAnTHErS library".format(scheme))
    return appliName

def getSchemeName(scheme) :
    schemeName = ""
    if scheme == FV_ID :
        schemeName = "FV"
    elif scheme == YASHE_ID :
        schemeName = "YASHE"
    elif scheme == FNTRU_ID :
        schemeName = "FNTRU"
    else :
        raise Exception("getSchemeName: scheme of ID {} is not in PAnTHErS library".format(scheme))
    return schemeName

def getApplicationDepth(appli) :
    depth = 0
    appliName = getApplicationName(appli)
    if appliName == MEDICAL_APP_NAME :
        depth = 12
    elif appliName == TOY_APP_NAME :
        depth = 10
    elif appliName == FIVEHB_APP_NAME :
        depth = 1
    elif appliName == CROISSANT_APP_NAME :
        depth = 6
    return depth
