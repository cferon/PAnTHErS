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


import time
import psutil
from tkinter import ttk
import os
import gc
from sage.all_cmdline import *
from sage.all import *
from sage.stats.distributions.discrete_gaussian_polynomial import DiscreteGaussianDistributionPolynomialSampler

attach("~/panthers/builder.sage")
attach("~/panthers/Calibration/calibration.sage")

builder = Builder()

def setPlaintextsAppliMedical(sex, age, antecedents, smoker, diabetes, highBloodPressure, HDLCholesterol, height, weight, physicalActivity, drinkingHabits) :
    res = []
    res = res + [highBloodPressure]
    res = res + [diabetes]
    res = res + [smoker]
    res = res + [antecedents]
    res = res + [sex]

    age = Integer(age).digits(2, padto = 8)
    age.reverse()
    res = res + age

    HDLCholesterol = Integer(HDLCholesterol).digits(2, padto = 8)
    HDLCholesterol.reverse()
    res = res + HDLCholesterol

    height = Integer(height).digits(2, padto = 8)
    height.reverse()
    res = res + height

    weight = Integer(weight).digits(2, padto = 8)
    weight.reverse()
    res = res + weight

    physicalActivity = Integer(physicalActivity).digits(2, padto = 8)
    physicalActivity.reverse()
    res = res + physicalActivity

    drinkingHabits = Integer(drinkingHabits).digits(2, padto = 8)
    drinkingHabits.reverse()
    res = res + drinkingHabits

    return res

def createSchemeWithPlaintextsAppliMedical(scheme, params, sets, plaintexts, whichAnalysis) :

    schemeObject = createSchemeObject(scheme, params, sets, whichAnalysis)

    [R,_,_] = sets

    mes = [builder.message("un", "plain", "poly", R(1),1,1,0,0)]
    for i in range(len(plaintexts)) :
        mes.append(builder.message("m" + str(i), "plain", "poly", R(plaintexts[i]),1,1,0,0))

    return schemeObject, mes

#Xor with keystream of 0 included
def computeApplicationMedical(scheme, plaintexts, R, progressBar = 0, step = 0) :
    nbOfOperations = 540.0
    nbOfMult = 106.0
    if step == 0 :
        step = 100

    paramProgress = step / nbOfMult

    typeCipher = "NoType"
    if isinstance(scheme, FV12) or isinstance(scheme, FV12Complexity) or isinstance(scheme, FV12Memory) :
        typeCipher = "poly"
    if isinstance(scheme, YASHE) or isinstance(scheme, YASHEComplexity) or isinstance(scheme, YASHEMemory) :
        typeCipher = "poly"
    if isinstance(scheme, FNTRU) or isinstance(scheme, FNTRUComplexity) or isinstance(scheme, FNTRUMemory) :
        typeCipher = "matrixPoly"

    def XOR(mes1, mes2) :
        add = scheme.heAdd.ope([mes1,mes2], ["Add"])[0]
        return add

    def AND(mes1, mes2) :
        mult = scheme.heMult.ope([mes1,mes2], ["Mult"])[0]
        if progressBar != 0 and paramProgress != 0 :
            progressBar.updateProgress(paramProgress)
        return mult

    def NOT(mes1) :
        R = PolynomialRing(ZZ, names=('z',)); (z,) = R._first_ngens(1)
        un = builder.message("un", "plain", typeCipher, R(1),1,1,0,0)
        [un] = scheme.heEnc.ope([un], [un])
        xorRes = XOR(mes1, un)
        return xorRes

    def OR(mes1, mes2) :
        orRes = XOR(XOR(mes1, mes2), AND(mes1, mes2))
        return orRes

    def ENC(mes1, mes2) :
        enc = scheme.heEnc.ope([mes1], [mes2])[0]
        return enc

    def DEC(mes1, mes2) :
        dec = scheme.heDec.ope([mes1], [mes2])[0]
        return dec

    def MESSAGE(name, group, type, value, row, col, depth, deg) :
        mes = builder.message(name, group, type, value, row, col, depth, deg)
        return mes

    def KEYGEN() :
        scheme.heKeyGen.ope()

    R2 = PolynomialRing(ZZ.quo(2*ZZ), names=('y',)); (y,) = R2._first_ngens(1)

    [un,i_61,i_62,i_63,i_64,i_65,i_66,i_67,i_68,i_69,i_70,i_71,i_72,i_73,i_74,i_75,i_76,i_77,i_78,i_79,i_80,i_81,i_82,i_83,i_84,i_85,i_86,i_87,i_88,i_89,i_90,i_91,i_92,i_93,i_94,i_95,i_96,i_97,i_98,i_99,i_100,i_101,i_102,i_103,i_104,i_105,i_106,i_107,i_108,i_109,i_110,i_111,i_112,i_113] = plaintexts

    KEYGEN()
    i_113 = ENC(i_113, "ci_113")
    i_112 = ENC(i_112, "ci_112")
    i_110 = ENC(i_110, "ci_110")
    i_109 = ENC(i_109, "ci_109")
    i_108 = ENC(i_108, "ci_108")
    i_107 = ENC(i_107, "ci_107")
    i_111 = ENC(i_111, "ci_111")
    i_106 = ENC(i_106, "ci_106")
    i_105 = ENC(i_105, "ci_105")
    i_104 = ENC(i_104, "ci_104")
    i_103 = ENC(i_103, "ci_103")
    i_102 = ENC(i_102, "ci_102")
    i_101 = ENC(i_101, "ci_101")
    i_100 = ENC(i_100, "ci_100")
    i_99 = ENC(i_99, "ci_99")
    i_98 = ENC(i_98, "ci_98")
    i_97 = ENC(i_97, "ci_97")
    i_96 = ENC(i_96, "ci_96")
    i_95 = ENC(i_95, "ci_95")
    i_94 = ENC(i_94, "ci_94")
    i_93 = ENC(i_93, "ci_93")
    i_92 = ENC(i_92, "ci_92")
    i_91 = ENC(i_91, "ci_91")
    i_90 = ENC(i_90, "ci_90")
    i_89 = ENC(i_89, "ci_89")
    i_88 = ENC(i_88, "ci_88")
    i_87 = ENC(i_87, "ci_87")
    i_86 = ENC(i_86, "ci_86")
    i_85 = ENC(i_85, "ci_85")
    i_84 = ENC(i_84, "ci_84")
    i_83 = ENC(i_83, "ci_83")
    i_82 = ENC(i_82, "ci_82")
    i_81 = ENC(i_81, "ci_81")
    i_80 = ENC(i_80, "ci_80")
    i_79 = ENC(i_79, "ci_79")
    i_78 = ENC(i_78, "ci_78")
    i_77 = ENC(i_77, "ci_77")
    i_76 = ENC(i_76, "ci_76")
    i_75 = ENC(i_75, "ci_75")
    i_74 = ENC(i_74, "ci_74")
    i_73 = ENC(i_73, "ci_73")
    i_72 = ENC(i_72, "ci_72")
    i_71 = ENC(i_71, "ci_71")
    i_70 = ENC(i_70, "ci_70")
    i_69 = ENC(i_69, "ci_69")
    i_68 = ENC(i_68, "ci_68")
    i_67 = ENC(i_67, "ci_67")
    i_66 = ENC(i_66, "ci_66")
    i_65 = ENC(i_65, "ci_65")
    i_64 = ENC(i_64, "ci_64")
    i_63 = ENC(i_63, "ci_63")
    i_62 = ENC(i_62, "ci_62")
    i_61 = ENC(i_61, "ci_61")
    i_57	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_57	= ENC(i_57, i_57)
    n450	= XOR(i_113, i_57)
    i_56	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_56	= ENC(i_56, i_56)
    n449	= XOR(i_112, i_56)
    i_55	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_55	= ENC(i_55, i_55)
    n433	= NOT(i_55)
    n434	= XOR(i_111, n433)
    n435	= NOT(n434)
    i_53	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_53	= ENC(i_53, i_53)
    i_54	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_54	= ENC(i_54, i_54)
    n430	= NOT(i_54)
    n431	= XOR(i_110, n430)
    n448	= AND(n434, n431)
    n451	= AND(n450, n449)
    i_52	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_52	= ENC(i_52, i_52)
    n432	= NOT(n431)
    n416	= NOT(i_53)
    n436	= AND(n435, n431)
    n417	= XOR(i_109, n416)
    n418	= NOT(n417)
    i_50	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_50	= ENC(i_50, i_50)
    i_51	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_51	= ENC(i_51, i_51)
    n411	= NOT(i_51)
    n412	= XOR(i_107, n411)
    n423	= NOT(n412)
    n414	= NOT(i_52)
    n415	= XOR(i_108, n414)
    n428	= AND(n417, n415)
    n409	= NOT(i_50)
    n410	= XOR(i_106, n409)
    n424	= AND(n423, n410)
    i_49	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_49	= ENC(i_49, i_49)
    n413	= AND(n412, n410)
    n419	= AND(n418, n415)
    n390	= NOT(i_49)
    n391	= XOR(i_105, n390)
    i_48	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_48	= ENC(i_48, i_48)
    n388	= NOT(i_48)
    n389	= XOR(i_104, n388)
    n395	= NOT(n389)
    n396	= AND(n391, n395)
    n429	= AND(n428, n413)
    n420	= XOR(n419, n415)
    n421	= NOT(n420)
    n422	= AND(n421, n413)
    n452	= AND(n451, n448)
    i_47	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_47	= ENC(i_47, i_47)
    n383	= NOT(i_47)
    n384	= XOR(i_103, n383)
    n385	= NOT(n384)
    i_46	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_46	= ENC(i_46, i_46)
    n437	= XOR(n436, n432)
    n380	= NOT(i_46)
    n381	= XOR(i_102, n380)
    n392	= OR(n391, n389)
    n382	= NOT(n381)
    n386	= AND(n385, n382)
    n425	= XOR(n424, n410)
    i_44	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_44	= ENC(i_44, i_44)
    n367	= NOT(i_44)
    n368	= XOR(i_100, n367)
    i_43	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_43	= ENC(i_43, i_43)
    n363	= NOT(i_43)
    n364	= XOR(i_99, n363)
    n370	= NOT(n364)
    i_45	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_45	= ENC(i_45, i_45)
    n374	= NOT(i_45)
    n375	= XOR(i_101, n374)
    n376	= NOT(n375)
    n377	= AND(n376, n368)
    i_42	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_42	= ENC(i_42, i_42)
    n361	= NOT(i_42)
    n362	= XOR(i_98, n361)
    n371	= AND(n370, n362)
    n365	= AND(n364, n362)
    n453	= XOR(n452, n437)
    n426	= XOR(n425, n422)
    n427	= NOT(n426)
    n397	= AND(n396, n386)
    n387	= NOT(n386)
    i_41	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_41	= ENC(i_41, i_41)
    n334	= XOR(i_97, i_41)
    i_40	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_40	= ENC(i_40, i_40)
    n250	= NOT(i_40)
    n251	= XOR(i_96, n250)
    n323	= NOT(n251)
    i_38	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_38	= ENC(i_38, i_38)
    n258	= NOT(i_38)
    n259	= XOR(i_94, n258)
    i_39	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_39	= ENC(i_39, i_39)
    n252	= NOT(i_39)
    n253	= XOR(i_95, n252)
    n324	= XOR(n253, n323)
    n325	= NOT(n324)
    n254	= NOT(n253)
    n255	= AND(n254, n251)
    i_37	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_37	= ENC(i_37, i_37)
    n262	= NOT(i_37)
    n263	= XOR(i_93, n262)
    n264	= NOT(n263)
    i_35	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_35	= ENC(i_35, i_35)
    n272	= NOT(i_35)
    n273	= XOR(i_91, n272)
    i_36	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_36	= ENC(i_36, i_36)
    n267	= NOT(i_36)
    n268	= XOR(i_92, n267)
    n269	= NOT(n268)
    n274	= NOT(n273)
    i_34	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_34	= ENC(i_34, i_34)
    n454	= AND(n453, n429)
    i_33	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_33	= ENC(i_33, i_33)
    n438	= AND(n437, n429)
    n393	= OR(n392, n387)
    n277	= NOT(i_34)
    n278	= XOR(i_90, n277)
    n335	= NOT(i_33)
    n336	= XOR(i_89, n335)
    n337	= AND(n336, n334)
    n378	= AND(n377, n365)
    n372	= XOR(n371, n362)
    n366	= NOT(n365)
    n369	= OR(n368, n366)
    n439	= XOR(n438, n427)
    i_32	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_32	= ENC(i_32, i_32)
    n398	= AND(n397, n378)
    n256	= XOR(n255, n251)
    n455	= XOR(n454, n426)
    n456	= NOT(n455)
    n379	= NOT(n378)
    n329	= NOT(i_32)
    n330	= XOR(i_88, n329)
    n333	= XOR(n330, n251)
    n257	= NOT(n256)
    n317	= XOR(n259, n257)
    n318	= NOT(n317)
    n331	= NOT(n330)
    n332	= OR(n331, n323)
    i_31	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_31	= ENC(i_31, i_31)
    n326	= NOT(i_31)
    n327	= XOR(i_87, n326)
    n344	= AND(n327, n324)
    n260	= AND(n259, n257)
    i_30	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_30	= ENC(i_30, i_30)
    n328	= XOR(n327, n325)
    n319	= NOT(i_30)
    n338	= AND(n337, n333)
    n394	= OR(n393, n379)
    n320	= XOR(i_86, n319)
    n342	= NOT(n320)
    n343	= OR(n342, n317)
    n373	= XOR(n372, n369)
    n321	= XOR(n320, n318)
    n322	= NOT(n321)
    i_29	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_29	= ENC(i_29, i_29)
    i_28	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_28	= ENC(i_28, i_28)
    n310	= NOT(i_29)
    n303	= NOT(i_28)
    n311	= XOR(i_85, n310)
    n304	= XOR(i_84, n303)
    n305	= NOT(n304)
    i_27	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_27	= ENC(i_27, i_27)
    n289	= NOT(i_27)
    n290	= XOR(i_83, n289)
    i_26	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_26	= ENC(i_26, i_26)
    n281	= NOT(i_26)
    n282	= XOR(i_82, n281)
    i_25	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_25	= ENC(i_25, i_25)
    n224	= NOT(i_25)
    n225	= XOR(i_81, n224)
    n226	= NOT(n225)
    i_24	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_24	= ENC(i_24, i_24)
    n221	= NOT(i_24)
    n222	= XOR(i_80, n221)
    n232	= AND(n225, n222)
    n261	= XOR(n260, n256)
    n308	= NOT(n261)
    n309	= XOR(n263, n308)
    n265	= AND(n264, n261)
    n345	= AND(n344, n321)
    n316	= XOR(n311, n309)
    n312	= AND(n311, n309)
    n227	= AND(n226, n222)
    n339	= XOR(n338, n332)
    n399	= XOR(n398, n394)
    n223	= NOT(n222)
    n340	= OR(n339, n328)
    i_23	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_23	= ENC(i_23, i_23)
    n216	= NOT(i_23)
    n217	= XOR(i_79, n216)
    n218	= NOT(n217)
    i_22	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_22	= ENC(i_22, i_22)
    n215	= XOR(i_78, i_22)
    n220	= AND(n217, n215)
    n400	= XOR(n399, n373)
    n219	= AND(n218, n215)
    i_21	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_21	= ENC(i_21, i_21)
    n211	= NOT(i_21)
    n212	= XOR(i_77, n211)
    n235	= NOT(n212)
    i_20	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_20	= ENC(i_20, i_20)
    n210	= XOR(i_76, i_20)
    n236	= AND(n235, n210)
    n346	= XOR(n345, n343)
    n213	= AND(n212, n210)
    n266	= XOR(n265, n261)
    n300	= NOT(n266)
    n301	= XOR(n268, n300)
    n302	= NOT(n301)
    n270	= AND(n269, n266)
    n307	= XOR(n304, n301)
    n233	= AND(n232, n220)
    n341	= OR(n340, n322)
    n313	= AND(n312, n307)
    n306	= OR(n305, n302)
    n228	= XOR(n227, n223)
    n229	= AND(n228, n220)
    i_19	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_19	= ENC(i_19, i_19)
    n207	= NOT(i_19)
    n208	= XOR(i_75, n207)
    n238	= NOT(n208)
    i_18	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_18	= ENC(i_18, i_18)
    n205	= NOT(i_18)
    n206	= XOR(i_74, n205)
    n239	= AND(n238, n206)
    n271	= XOR(n270, n266)
    n276	= NOT(n271)
    n288	= XOR(n273, n276)
    n295	= NOT(n288)
    n279	= XOR(n278, n276)
    n275	= AND(n274, n271)
    n296	= XOR(n290, n295)
    n291	= AND(n290, n288)
    n297	= NOT(n296)
    n209	= AND(n208, n206)
    n347	= XOR(n346, n341)
    n348	= AND(n347, n316)
    n314	= XOR(n313, n306)
    i_17	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_17	= ENC(i_17, i_17)
    n139	= NOT(i_17)
    n140	= XOR(i_73, n139)
    n151	= NOT(n140)
    i_16	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_16	= ENC(i_16, i_16)
    n137	= NOT(i_16)
    n138	= XOR(i_72, n137)
    n152	= AND(n151, n138)
    n150	= NOT(n138)
    n141	= OR(n140, n138)
    n230	= XOR(n229, n219)
    n240	= XOR(n239, n206)
    i_15	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_15	= ENC(i_15, i_15)
    i_14	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_14	= ENC(i_14, i_14)
    i_13	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_13	= ENC(i_13, i_13)
    n132	= NOT(i_14)
    n133	= XOR(i_70, n132)
    n134	= NOT(n133)
    n129	= XOR(i_69, i_13)
    i_12	= MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_12	= ENC(i_12, i_12)
    n128	= XOR(i_68, i_12)
    n130	= AND(n129, n128)
    n135	= XOR(i_71, i_15)
    n143	= AND(n135, n133)
    n280	= XOR(n279, n275)
    n285	= NOT(n280)
    n283	= AND(n282, n280)
    n286	= XOR(n282, n285)
    n287	= NOT(n286)
    n237	= AND(n236, n209)
    n298	= AND(n297, n287)
    n292	= AND(n291, n287)
    n349	= AND(n348, n307)
    n214	= AND(n213, n209)
    n153	= XOR(n152, n150)
    n144	= XOR(n143, n133)
    n154	= AND(n135, n134)
    n136	= OR(n135, n134)
    n284	= NOT(n283)
    n293	= XOR(n292, n284)
    n294	= NOT(n293)
    i_11	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_11	= ENC(i_11, i_11)
    n122	= NOT(i_11)
    n123	= XOR(i_67, n122)
    n124	= NOT(n123)
    i_10	= MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_10	= ENC(i_10, i_10)
    n120	= NOT(i_10)
    n121	= XOR(i_66, n120)
    n127	= AND(n123, n121)
    n241	= XOR(n240, n237)
    i_9	    = MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_9	    = ENC(i_9, i_9)
    n117	= NOT(i_9)
    n118	= XOR(i_65, n117)
    n457	= AND(n456, n118)
    n125	= AND(n124, n121)
    n299	= NOT(n298)
    n315	= OR(n314, n299)
    n350	= AND(n349, n298)
    n234	= AND(n233, n214)
    n231	= AND(n230, n214)
    n142	= OR(n141, n136)
    n119	= NOT(n118)
    n440	= AND(n439, n119)
    n131	= AND(n130, n127)
    i_8	    = MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_8	    = ENC(i_8, i_8)
    n164	= NOT(i_8)
    n165	= XOR(i_64, n164)
    n166	= NOT(n165)
    i_7	    = MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_7	    = ENC(i_7, i_7)
    n175	= NOT(i_7)
    n176	= XOR(i_63, n175)
    n177	= NOT(n176)
    i_6	    = MESSAGE("un", "plain", typeCipher, R(0),1,1,0,0)
    i_6	    = ENC(i_6, i_6)
    n126	= XOR(n125, n121)
    n185	= NOT(i_6)
    n186	= XOR(i_62, n185)
    n187	= NOT(n186)
    i_5	    = MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_5	    = ENC(i_5, i_5)
    n242	= XOR(n241, n234)
    n351	= XOR(n350, n315)
    n352	= XOR(n351, n294)
    n353	= NOT(n352)
    n195	= NOT(i_5)
    n196	= XOR(i_61, n195)
    n197	= NOT(n196)
    i_4	    = MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_4	    = ENC(i_4, i_4)
    i_3	    = MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_3	    = ENC(i_3, i_3)
    i_2	    = MESSAGE("zero", "plain", typeCipher, R(0),1,1,0,0)
    i_2	    = ENC(i_2, i_2)
    n243	= XOR(n242, n231)
    n145	= XOR(n144, n142)
    n155	= AND(n154, n131)
    n146	= AND(n145, n131)
    n147	= XOR(n146, n126)
    n148	= NOT(n147)
    n149	= AND(n148, n119)
    n156	= AND(n155, n153)
    n161	= NOT(n149)
    n157	= XOR(n156, n126)
    n158	= NOT(n157)
    n159	= AND(n158, n118)
    n162	= XOR(n159, n161)
    n160	= AND(n159, n149)
    n163	= NOT(n162)
    n173	= XOR(n165, n163)
    n167	= AND(n166, n163)
    n174	= NOT(n173)
    n183	= XOR(n176, n174)
    n178	= AND(n177, n174)
    n184	= NOT(n183)
    n193	= XOR(n186, n184)
    n188	= AND(n187, n184)
    n194	= NOT(n193)
    n203	= XOR(n196, n194)
    n198	= AND(n197, n194)
    n204	= NOT(n203)
    n249	= XOR(n243, n204)
    n359	= NOT(n249)
    n360	= XOR(n352, n359)
    n406	= NOT(n360)
    n354	= AND(n353, n249)
    n407	= XOR(n400, n406)
    n401	= AND(n400, n360)
    n446	= XOR(n440, n407)
    n447	= NOT(n446)
    m_3	    = XOR(n457, n447)
    n458	= AND(n457, n447)
    n408	= NOT(n407)
    n168	= AND(n167, n160)
    n441	= AND(n440, n408)
    n170	= NOT(n160)
    n171	= XOR(n167, n170)
    n244	= AND(n243, n204)
    n172	= NOT(n171)
    n181	= XOR(n178, n171)
    n179	= AND(n178, n172)
    n182	= NOT(n181)
    n191	= XOR(n188, n181)
    n189	= AND(n188, n182)
    n192	= NOT(n191)
    n201	= XOR(n198, n191)
    n202	= NOT(n201)
    n199	= AND(n198, n192)
    n247	= XOR(n244, n201)
    n357	= XOR(n354, n247)
    n245	= AND(n244, n202)
    n404	= XOR(n401, n357)
    n444	= XOR(n441, n404)
    n445	= NOT(n444)
    m_2	    = XOR(n458, n445)
    n405	= NOT(n404)
    n459	= AND(n458, n445)
    n169	= NOT(n168)
    n180	= XOR(n179, n169)
    n472	= NOT(n179)
    n474	= NOT(n180)
    n473	= OR(n472, n169)
    n442	= AND(n441, n405)
    n358	= NOT(n357)
    n402	= AND(n401, n358)
    n248	= NOT(n247)
    n355	= AND(n354, n248)
    n475	= AND(n189, n474)
    n190	= XOR(n189, n180)
    n470	= NOT(n190)
    n471	= AND(n199, n470)
    n200	= XOR(n199, n190)
    n460	= NOT(n459)
    n246	= XOR(n245, n200)
    n466	= NOT(n246)
    n468	= NOT(n200)
    n469	= AND(n245, n468)
    n467	= AND(n355, n466)
    n356	= XOR(n355, n246)
    n464	= NOT(n356)
    n465	= AND(n402, n464)
    n403	= XOR(n402, n356)
    n462	= NOT(n403)
    n463	= AND(n442, n462)
    n443	= XOR(n442, n403)
    n483	= NOT(n443)
    m_1	    = XOR(n459, n483)
    n476	= XOR(n475, n473)
    n461	= OR(n460, n443)
    n477	= XOR(n476, n471)
    n478	= XOR(n477, n469)
    n479	= XOR(n478, n467)
    n480	= XOR(n479, n465)
    n481	= XOR(n480, n463)
    m_0	    = XOR(n481, n461)
    m_3Decrypted = DEC(m_3, "m_3Decrypted")
    m_2Decrypted = DEC(m_2, "m_2Decrypted")
    m_1Decrypted = DEC(m_1, "m_1Decrypted")
    m_0Decrypted = DEC(m_0, "m_0Decrypted")

    return int(R2(m_0Decrypted.value))*8 + int(R2(m_1Decrypted.value))*4 + int(R2(m_2Decrypted.value))*2 + int(R2(m_3Decrypted.value))*1, int(R2(m_0Decrypted.value))*1 + int(R2(m_1Decrypted.value))*2 + int(R2(m_2Decrypted.value))*4 + int(R2(m_3Decrypted.value))*8

def appliMedical(execOrAnalyse, scheme, params, progressBar) :
    paramsCopy = [ParamVariation(params[k]) for k in range(len(params))]

    schemeName = getSchemeName(scheme)

    graphsName = []

    for i in range(len(params)) :
        if not(params[i].isFixed) :
            print("Starting analysis of complexity with {} parameter variation".format(params[i].name))
            axeName = [params[i].name]
            paramsFixed = ""
            if execOrAnalyse == COMPLEXITY_ANALYSIS_ID :
                paramsFixed = "Time "
            elif execOrAnalyse == MEMORY_ANALYSIS_ID :
                paramsFixed = "MiB "
            paramsCopy = [ParamVariation(params[k]) for k in range(len(params))]
            for j in range(len(paramsCopy)) :
                if i != j :
                    paramsCopy[j].isFixed = True
                    paramsFixed = paramsFixed + "\n" + paramsCopy[j].name + "=" + str(paramsCopy[j].default) + " "
            axeName = axeName + [paramsFixed]

            fileName = params[i].generateFileName(execOrAnalyse, "appli_med_" + schemeName, paramsCopy)
            file = open("Res/" + fileName + ".csv", "w")
            file.write(params[i].name + "\t")
            file.write(axeName[1])
            file.write("\n")
            graphsName = graphsName + [fileName]

            progressBar.findPrefixeProgressBarLabel(scheme, paramsCopy)
            calibratedPoints = []

            if execOrAnalyse == EXECUTION_ID :#execution
                calibratedPoints = executeAppliMedical(scheme, paramsCopy, file, progressBar)
            elif execOrAnalyse == COMPLEXITY_ANALYSIS_ID or execOrAnalyse == MEMORY_ANALYSIS_ID : #analyse
                points = analyzeAppliMedical(scheme, paramsCopy, execOrAnalyse, file, progressBar)
                file.close()

                print("Analysis of complexity ({}): done".format(params[i].name))
                print("Starting calibration")

                practicalPoints = getMedical2PracticalValues(execOrAnalyse, scheme, fileName, paramsCopy, points, progressBar)

                progressBar.configure("2-calibration: conversion")
                calibreTime1 = time.time()
                calibratedPoints = calibrate(practicalPoints, points)
                calibreTime2 = time.time()
                progressBar.updateProgress(100)

                pracFile = open("Res/calibrated_"+fileName + ".csv", "w")
                for iParam in range(len(calibratedPoints)) :
                    pracFile.write(str(calibratedPoints[iParam][0]) + "\t" + str(calibratedPoints[iParam][1]) + "\n")
                pracFile.close()

                for param in params :
                    param.currentValue = 0

                print("Calibration: done")
            print("Starting graph generation")

            progressBar.configure("Graph generation")
            generateGraph(axeName, calibratedPoints, fileName)
            progressBar.updateProgress(100)

            print("Graph {} generated".format(fileName))

    return graphsName

def analyzeAppliMedical(scheme, paramsIn, whichAnalysis, file, progressBar) :
    progressBar.configure("analysis")

    nbOfSteps = 0
    for param in paramsIn :
        if not(param.isFixed) :
            nbOfSteps = ceil((param.max - param.min + 1)/ float(param.step))

    for param in paramsIn :
        param.getInitParamVariationValue()

    isTerminated = False
    for param in paramsIn :
        isTerminated = isTerminated or param.isMaxValueReached()

    pointsList = []

    while not(isTerminated) :
        textToPrint = ""
        for param in paramsIn :
            textToPrint = textToPrint + "{} = {} ".format(param.name, param.currentValue)
        print(textToPrint)

        pointsList = panthersAppliMedicalOnce(scheme, paramsIn, whichAnalysis, file, pointsList) #analyse

        for param in paramsIn :
            param.getNextParamVariationValue()

        isTerminated = False
        for param in paramsIn :
            isTerminated = isTerminated or param.isMaxValueReached()
        progressBar.updateProgress(100 / float(nbOfSteps))

    for param in paramsIn :
        param.currentValue = 0

    return pointsList

def executeAppliMedical(scheme, paramsIn, file, progressBar) :
    progressBar.configure("execution")

    nbOfSteps = 0
    for param in paramsIn :
        if not(param.isFixed) :
            nbOfSteps = ceil((param.max - param.min + 1)/ float(param.step))

    for param in paramsIn :
        param.getInitParamVariationValue()

    isTerminated = False
    for param in paramsIn :
        isTerminated = isTerminated or param.isMaxValueReached()

    pointsList = []

    while not(isTerminated) :
        textToPrint = ""
        for param in paramsIn :
            textToPrint = textToPrint + "{} = {} ".format(param.name, param.currentValue)
        print(textToPrint)

        pointsList = executeAppliMedicalOnce(scheme, paramsIn, progressBar, 100/float(nbOfSteps), file, pointsList) #execute

        for param in paramsIn :
            param.getNextParamVariationValue()

        isTerminated = False
        for param in paramsIn :
            isTerminated = isTerminated or param.isMaxValueReached()
        progressBar.updateProgress(100 / float(nbOfSteps))

    for param in paramsIn :
        param.currentValue = 0

    return pointsList

def executeAppliMedicalOnce(scheme, paramsIn, progressBar = 0, step = 0, file = 0, pointsList = 0) :
    practicalAnalysis = executePracticalAnalysis(MEDICAL_ID, EXECUTION_ID, "Practical_executeAppliMedicalOnce", scheme, paramsIn, progressBar)

    if pointsList != 0 :
        for param in paramsIn :
            if not(param.isFixed) :
                pointsList = pointsList + [(param.currentValue,practicalAnalysis)]
                file.write(str(param.currentValue) + "\t" + str(practicalAnalysis) + "\n")
        return pointsList
    else :
        raise Exception("executeAppliMedicalOnce: pointsList must be != 0.")

def panthersAppliMedicalOnce(scheme, paramsIn, whichAnalysis, file, pointsList) :
    param, sets = chooseParameter(scheme, paramsIn)
    #sex, age, ante, smoke, diabetes, highBlood, HDLChol, h, w, physicalActivity, drinkingHabits
    plain = setPlaintextsAppliMedical(1,65,1,1,1,1,60,190,60,45,4)
    schemeObject, mes = createSchemeWithPlaintextsAppliMedical(scheme, param, sets, plain, whichAnalysis)
    res = computeApplicationMedical(schemeObject, mes, sets[0])
    analysis = 0
    if whichAnalysis == COMPLEXITY_ANALYSIS_ID :
        analysis = schemeObject.globalComplexity()
    elif whichAnalysis == MEMORY_ANALYSIS_ID :
        q = schemeObject.q.value
        analysis = schemeObject.globalMemory(q, "Atom", 32)
    else :
        raise Exception("panthersAppliMedicalOnce: schemeObject is not a HESchemeComplexity or a HESchemeMemory but a {}".format(type(schemeObject)))

    isOneParamFixed = False
    for param in paramsIn :
        if not(param.isFixed) :
            isOneParamFixed = True
            pointsList = pointsList + [(param.currentValue,analysis)]
            file.write(str(param.currentValue) + "\t" + str(analysis) + "\n")
    if isOneParamFixed == False :
        params = []
        if not(isinstance(pointsList, list)) :
            file.write(str(pointsList)+"\t")
            for i in range(len(paramsIn)) :
                params = params + [paramsIn[i].currentValue]
                file.write(str(paramsIn[i].currentValue) + "\t")
            file.write(str(analysis) + "\n")
        return analysis

    return pointsList

def getMedical2PracticalValues(whichAnalysis, scheme, fileName, params, points, progressBar) :
    practicalValues = []
    for j in range(len(params)) :
        if params[j].isFixed :
            params[j].currentValue = params[j].default
        else :
            params[j].currentValue = params[j].min

    progressBar.configure("2-calibration (1st execution)")
    practicalAnalysis1 = executePracticalAnalysis(MEDICAL_ID, whichAnalysis, "Practical_1_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min, practicalAnalysis1)]

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].max

    progressBar.configure("2-calibration (2nd execution)")
    practicalAnalysis2 = executePracticalAnalysis(MEDICAL_ID, whichAnalysis, "Practical_2_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].max, practicalAnalysis2)]

    return practicalValues
