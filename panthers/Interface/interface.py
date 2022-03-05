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


from functools import partial
from tkinter import *
from PIL import ImageTk
from tkinter import ttk
from tkinter.ttk import *
import time

attach("../const_id.sage")
attach("../Analyse/analyse.py")
attach("../Interface/schemeinterface.py")
attach("../Interface/progress.py")
attach("../Interface/graphinterface.py")
attach("../Interface/parameterinterface.py")

class Interface(Frame):

    def __init__(self, fenetre, app = 0, scheme = 0, **kwargs):
        fenetre.geometry("1550x500")
        Frame.__init__(self, fenetre, **kwargs)

        self.pack(fill=BOTH)

        self.app = 0
        self.scheme = 0

        #Frame definition
        self.analyzeFrame = LabelFrame(self, height=500, width=270, padx="10px")
        self.analyzeFrame.grid(row=1, column=1, sticky='n')
        self.analyzeFrame.grid_propagate(False)

        self.grid_rowconfigure(2, minsize="110px")
        self.appFrame = LabelFrame(self, height=500, width=220, padx="10px")
        self.appFrame.grid(row=1, column=2, sticky='n')
        self.appFrame.grid_propagate(False)

        self.schemeFrame = LabelFrame(self, height=500, width=200, padx="10px")
        self.schemeFrame.grid(row=1, column=3, sticky='n')
        self.schemeFrame.grid_propagate(False)

        self.paramFrame = LabelFrame(self, height=500, width=290, padx="10px")
        self.paramFrame.grid(row=1, column=4, sticky='n')
        self.paramFrame.grid_propagate(False)

        self.confirmFrame = LabelFrame(self, height=500, width=350, padx="10px")
        self.confirmFrame.grid(row=1, column=5, sticky='n')
        self.confirmFrame.grid_propagate(False)

        #Scheme creation
        self.nbOfRow = 4
        self.fv = SchemeInterface(self.schemeFrame, self.paramFrame, "FV", FV_ID, 3, ["log(q)", "t", "log(w)"], self.nbOfRow)
        self.updateNbOfRow(self.fv)
        self.yashe = SchemeInterface(self.schemeFrame, self.paramFrame, "YASHE", YASHE_ID, 3, ["log(q)", "t", "log(w)"], self.nbOfRow)
        self.updateNbOfRow(self.yashe)
        self.fntru = SchemeInterface(self.schemeFrame, self.paramFrame, "FNTRU", FNTRU_ID, 2, ["log(q)", "log(w)"], self.nbOfRow)
        self.updateNbOfRow(self.fntru)
        self.schemeList = [self.fv, self.yashe, self.fntru]
        self.defaultValues(0)

        # Frame Analysis
        self.execOrAnalysis =  Label(self.analyzeFrame, text="Choose execution or analysis", font="Calibri 10 bold")
        self.execOrAnalysis.grid(row=1, column=1, sticky=N+E+W+S, columnspan=2)
        self.valueBtnExecOrAnalysis = StringVar()
        self.exploType = Label(self.analyzeFrame, text="Select exploration type", font="Calibri 10 bold")
        self.exploTypeValue = IntVar()
        self.exploTypeCompromise = Radiobutton(self.analyzeFrame, variable=self.exploTypeValue, value=0, text="Best compromise")
        self.exploTypeComp = Radiobutton(self.analyzeFrame, variable=self.exploTypeValue, value=1, text="Low complexity")
        self.exploTypeMem = Radiobutton(self.analyzeFrame, variable=self.exploTypeValue, value=2, text="Low memory cost")
        self.options = Label(self.analyzeFrame, text="Options", font="Calibri 10 bold")
        self.compMaxLabel = Label(self.analyzeFrame, text="execution time max in seconds: ")
        self.compMaxValueInt = IntVar()
        self.compMaxValue = Entry(self.analyzeFrame, textvariable=self.compMaxValueInt, width=4)
        self.memMaxLabel = Label(self.analyzeFrame, text="memory cost max in MiB: ")
        self.memMaxValueInt = IntVar()
        self.memMaxValue = Entry(self.analyzeFrame, textvariable=self.memMaxValueInt, width=4)
        self.showExecOrAnalysis(2)

        # Frame Application
        self.app_text =  Label(self.appFrame, text="Choose one application", font="Calibri 10 bold")
        self.app_text.grid(row=1, column=1, sticky=N+E+W+S, columnspan=7)
        self.valueBtnApp = StringVar()
        self.valueBtnSecu = IntVar()
        self.security = Label(self.appFrame, text="Choose wanted security", font="Calibri 10 bold")
        self.bouton80   = Radiobutton(self.appFrame, variable=self.valueBtnSecu, value=80, text="80 bits")
        self.bouton128 = Radiobutton(self.appFrame, variable=self.valueBtnSecu, value=128, text="128 bits")
        self.depth = Label(self.appFrame, text="Choose range of depth", font="Calibri 10 bold")
        self.depthVar = ParameterInterface(self.appFrame, "Depth")
        self.depthVarValid = Button(self.appFrame, text="Confirm depth", command=self.validExplo)
        self.showApp(2)

        # Frame Scheme
        self.scheme_text =  Label(self.schemeFrame, text="Choose HE scheme(s)", font="Calibri 10 bold")
        self.showSchemeSelection()

        # Frame Parameter
        self.param_text =  Label(self.paramFrame, text="Fill parameters variation", font="Calibri 10 bold")
        self.bouton_confirm = Button(self.paramFrame, text="Confirm", command=self.confirmChoice)
        self.bouton_reset = Button(self.paramFrame, text="Reset", command=self.resetParam)
        self.bouton_default = Button(self.paramFrame, text="Default Value", command=self.defaultParam)
        self.bouton_confirm.grid(row=self.nbOfRow+1, column=5, columnspan=3)
        self.bouton_reset.grid(row=self.nbOfRow+1, column=3, columnspan=2)
        self.bouton_default.grid(row=self.nbOfRow+1, column=1, columnspan=2)
        self.param_text.grid(row=1, column=1, padx='10px', sticky='n', columnspan=7)

        # Frame Confirmation
        self.confirm_text =  Label(self.confirmFrame, text="Analysis", font="Calibri 10 bold")
        self.confirm_text.grid(row=1, column=1, padx='75px')
        self.labelVar = StringVar()
        self.labelConfirmation = Label(self.confirmFrame,textvariable= self.labelVar)
        self.labelConfirmation.grid(row=2, column=1)
        self.labelVar.set("Nothing to execute or analyze.")
        self.labelConfirmation.config(justify=LEFT)
        self.depthButton = Button(self.confirmFrame, text="Check depth", command=self.confirmDepth)
        self.depthLabelVar = StringVar()
        self.depthLabel = Label(self.confirmFrame,textvariable= self.depthLabelVar)
        self.exploRecapVar = StringVar()
        self.exploRecap = Label(self.confirmFrame,textvariable= self.exploRecapVar)

        # Analyze button
        self.startAnalyzeButton = Button(self.confirmFrame, text="Start analysis",command=self.startAnalyze)
        self.analyzeConfirmation = Label(self.confirmFrame, text="Analyses finished!")
        self.showGraphButton = Button(self.confirmFrame, text="Display Graphs",command=self.showGraphs)
        self.graphsName = []

        # Quit button
        self.bouton_quitter = Button(self, text="Quit", command=fenetre.destroy)
        self.bouton_quitter.grid(row=2, column=5)

        # ProgressBar
        self.progressBar = Progress(self.confirmFrame, "LabeledProgressbar", 300)

    def defaultValues(self, analyzeOrExplo) :
        """analyzeOrExplo: 0 (analyze), 1 (explo) """
        if analyzeOrExplo == ANALYZE_ID :
            self.fv.params[0].forDefaultButton = [100,300,10,100]
            self.fv.params[1].forDefaultButton = [2,40,2,2]
            self.fv.params[2].forDefaultButton = [2,64,2,2]

            self.yashe.params[0].forDefaultButton = [100,300,10,100]
            self.yashe.params[1].forDefaultButton = [2,40,2,2]
            self.yashe.params[2].forDefaultButton = [2,60,2,2]

            self.fntru.params[0].forDefaultButton = [60,100,5,60]
            self.fntru.params[1].forDefaultButton = [2,40,2,2]

        else :
            self.fv.params[0].forDefaultButton = [2,1000,1,2]
            self.fv.params[1].forDefaultButton = [2,1000,1,2]
            self.fv.params[2].forDefaultButton = [2,1000,1,2]

            self.yashe.params[0].forDefaultButton = [2,1000,1,2]
            self.yashe.params[1].forDefaultButton = [2,1000,1,2]
            self.yashe.params[2].forDefaultButton = [2,1000,1,2]

            self.fntru.params[0].forDefaultButton = [2,1000,1,2]
            self.fntru.params[1].forDefaultButton = [2,1000,1,2]

    def confirmChoice(self) :
        self.startAnalyzeButton.grid_forget()
        self.analyzeConfirmation.grid_forget()
        self.showGraphButton.grid_forget()
        self.exploRecap.grid_forget()

        oneSchemeSelected = False
        for scheme in self.schemeList :
            if scheme.is_checked.get() :
                oneSchemeSelected = True

        if self.valueBtnApp.get() == "" :
            self.startAnalyzeButton.grid_forget()

            if not(oneSchemeSelected) :
                self.labelVar.set("No Application selected.\nNo Scheme selected.")
            else :
                self.labelVar.set("No Application selected.")

        elif oneSchemeSelected :
            self.exploRecap.grid_forget()

            self.startAnalyzeButton.config(text="Start analysis")
            print(getApplicationName(self.valueBtnApp.get()))
            msg = "Application chosen: " + getApplicationName(self.valueBtnApp.get())
            msg = msg + "\nSchemes chosen: "
            for scheme in self.schemeList :
                if scheme.is_checked.get() :
                    print(scheme.name)
                    msg = msg + scheme.name + " "

            msg = msg + "\nParameter variations: "
            variation = True
            for scheme in self.schemeList :
                if scheme.is_checked.get() :
                    msg = msg + "\n" + scheme.name + ":"

                    for param in scheme.params :
                        diff = abs(param.maxInt.get()-param.minInt.get())
                        if param.maxInt.get() < param.minInt.get() :
                            msg = msg + "\n\t" + param.name + " : Error (max < min)."
                            self.labelVar.set(msg)
                            self.startAnalyzeButton.grid_forget()
                            variation = False
                        elif diff < param.stepInt.get() :
                            msg = msg + "\n\t" + param.name + " : Error (step too big)."
                            self.labelVar.set(msg)
                            self.startAnalyzeButton.grid_forget()
                            variation = False
                        elif diff >= 0 and param.stepInt.get() == 0 and param.maxInt.get() != 0 :
                            msg = msg + "\n\t" + param.name + " : Error (no step)."
                            self.labelVar.set(msg)
                            self.startAnalyzeButton.grid_forget()
                            variation = False
                        elif param.defaultInt.get() == 0 :
                            msg = msg + "\n\t" + param.name + " : Default parameter not specified."
                            self.labelVar.set(msg)
                            self.startAnalyzeButton.grid_forget()
                            variation = False
                        elif param.minInt.get() > 0 and param.maxInt.get() > 0 and param.stepInt.get() > 0 and param.defaultInt.get() > 0 :
                            msg = msg + "\n\t" + param.name + " = " + str(param.minInt.get()) + " to " + str(param.maxInt.get()) + " by " +  str(param.stepInt.get()) + ", default = " + str(param.defaultInt.get())
                            param.hasToBeAnalyzed = True
                            self.labelVar.set(msg)
                            self.startAnalyzeButton.grid_forget()
                        else :
                            msg = msg + "\n\t" + param.name + " : No variation."
                            param.hasToBeAnalyzed = False
                            self.labelVar.set(msg)
                            self.startAnalyzeButton.grid_forget()

            if not(variation) :
                self.startAnalyzeButton.grid_forget()
                self.exploRecap.grid_forget()

            elif self.valueBtnExecOrAnalysis.get() == str(EXPLORATION_ID) :
                self.depthButton.grid_forget()
                self.depthLabel.grid_forget()

                appli = getApplicationName(self.valueBtnApp.get())
                depthMin = self.depthVar.minInt.get()
                depthMax = self.depthVar.maxInt.get()
                depthStep = self.depthVar.stepInt.get()
                secu = self.valueBtnSecu.get()
                exploreType = self.exploTypeValue.get()
                if exploreType == 0 :
                    exploreType = "best compromise between\n complexity and memory cost"
                elif exploreType == 1 :
                    exploreType = "lowest complexity"
                else :
                    exploreType = "lowest memory cost"
                compMax = self.compMaxValueInt.get()
                memMax = self.memMaxValueInt.get()
                if compMax == 0 :
                    compMax = "infinity"
                if memMax == 0 :
                    memMax = "infinity"

                textExplo = "Exploration will test {} application\n with all sets of parameters implying a\n depth = {} to {} by {}\n and a {}-bit security for all schemes.\n Final sets returns\n {}\n and will imply\n application time execution < {},\n and memory resources < {}.".format(appli, depthMin, depthMax, depthStep, secu, exploreType, compMax, memMax)

                self.exploRecapVar.set(textExplo)
                self.exploRecap.grid(row=6, column=1)

                self.startAnalyzeButton.config(text="Start Exploration")
                self.startAnalyzeButton.grid(row=7, column=1)

            else :
                self.depthButton.grid(row=4,column=1)
                self.depthLabelVar.set("Depth was not evaluated.")
                self.depthLabel.grid(row=5, column=1)
                self.startAnalyzeButton.grid(row=6, column=1)

            for scheme in self.schemeList :
                for param in scheme.params :
                    if not(param.minInt.get() == 0 and param.maxInt.get() == 0 or param.stepInt.get() == 0) :
                        variation = True

            if not(variation) :
                self.startAnalyzeButton.grid_forget()
        else :
            self.labelVar.set("No Scheme selected")
            self.startAnalyzeButton.grid_forget()

    def validExplo(self) :
        self.startAnalyzeButton.grid_forget()
        self.exploRecap.grid_forget()

        if self.valueBtnSecu.get() != 80 and self.valueBtnSecu.get() != 128 :
            self.labelVar.set("No security selected.")
        elif self.depthVar.minInt.get() < getApplicationDepth(self.valueBtnApp.get()) :
            self.labelVar.set("{} application has a minimum depth\n of {} (> {}).".format(getApplicationName(self.valueBtnApp.get()), getApplicationDepth(self.valueBtnApp.get()), self.depthVar.minInt.get()))
        elif self.depthVar.minInt.get() > self.depthVar.maxInt.get() :
            self.labelVar.set("Minimum depth must be < to maximum depth (min = {} > max = {}).".format(self.depthVar.minInt.get(),self.depthVar.maxInt.get()))
        elif self.depthVar.minInt.get() < self.depthVar.maxInt.get() and self.depthVar.stepInt.get() <= 0 :
            self.labelVar.set("Step for depth must be > 0.")
        else :
            for scheme in self.schemeList :
                scheme.is_checked.set(True)
                scheme.showParamsVariation()
                for param in scheme.params :
                    param.minInt.set(2)
                    param.maxInt.set(1000)
                    param.stepInt.set(1)
                    param.defaultInt.set(2)

            self.defaultValues(1)

            self.labelVar.set("Nothing to analyze.")
            self.depthButton.grid_forget()
            self.depthLabel.grid_forget()

    def confirmDepth(self) :
        self.depthLabel.grid_forget()
        appId = eval(self.valueBtnApp.get())
        finalResult = 1
        errorMessage = ""

        for scheme in self.schemeList :
            if scheme.is_checked.get() :
                params = []
                for param in scheme.params :
                    params = params + [param.createParamVariation()]
                res, errorMessage = depthAppliCheck(appId, scheme.idNumber, params)
                if res == 0 :
                    finalResult = 0
                    self.depthLabel.grid(row=5, column=1)
                    self.depthLabelVar.set(errorMessage)
        if finalResult :
            self.depthLabel.grid(row=5, column=1)
            self.depthLabelVar.set(errorMessage)

    def resetParam(self) :
        for scheme in self.schemeList :
            for param in scheme.params :
                param.minInt.set(0)
                param.maxInt.set(0)
                param.stepInt.set(0)
                param.defaultInt.set(0)

    def defaultParam(self) :
        for scheme in self.schemeList :
            if scheme.is_checked.get() :
                for param in scheme.params :
                    default = param.forDefaultButton
                    param.minInt.set(default[0])
                    param.maxInt.set(default[1])
                    param.stepInt.set(default[2])
                    param.defaultInt.set(default[3])

    def startAnalyze(self) :
        self.progressBar.grid(row=20, column=1)
        self.progressBar.update_idletasks()
        self.graphsName = []

        if self.valueBtnExecOrAnalysis.get() != str(EXPLORATION_ID) :
            self.analyzeConfirmation.config(text="Analyses finished!")
            for scheme in self.schemeList :
                if scheme.is_checked.get() :
                    params = []
                    for param in scheme.params :
                        params = params + [param.createParamVariation()]
                    print("Start Analyze : ", int(self.valueBtnExecOrAnalysis.get())-1)
                    self.graphsName = self.graphsName + bench(eval(self.valueBtnExecOrAnalysis.get()), eval(self.valueBtnApp.get()), scheme.idNumber, params, self.progressBar)

            self.progressBar.grid_forget()
            self.analyzeConfirmation.grid(row=21, column=1)
            self.showGraphButton.grid(row=22, column=1)
        else :
            exploreType = self.exploTypeValue.get()
            secu = self.valueBtnSecu.get()
            if self.depthVar.minInt.get() == self.depthVar.maxInt.get() :
                depth = self.depthVar.minInt.get()
            else :
                depth = [i for i in range(self.depthVar.minInt.get(), self.depthVar.maxInt.get()+1, self.depthVar.stepInt.get())]
            compMax = self.compMaxValueInt.get()
            memMax = self.memMaxValueInt.get()

            tabMinMax = self.selectMinMaxVariationPerScheme()

            schemeExplored = []
            for scheme in self.schemeList :
                if scheme.is_checked.get() :
                    schemeExplored = schemeExplored + [scheme.idNumber]

            appliExploration(eval(self.valueBtnApp.get()), schemeExplored, tabMinMax, self.progressBar, exploreType, secu, depth, compMax, memMax)

            self.defaultValues(0)
            self.progressBar.grid_forget()
            self.analyzeConfirmation.config(text="Exploration finished!")
            self.analyzeConfirmation.grid(row=21, column=1)
            self.showGraphButton.grid(row=22, column=1)

    def selectMinMaxVariationPerScheme(self) :
        tab = [0,0,0]
        for i in range(len(self.schemeList)) :
            paramScheme = []
            for param in self.schemeList[i].params :
                paramScheme.append(param.minInt.get())
                paramScheme.append(param.maxInt.get())
            tab[i] = paramScheme

        return tab

    def showApp(self, fromRow) :
        self.appFrame.boutonAppMed   = Radiobutton(self.appFrame, variable=self.valueBtnApp, value=MEDICAL_ID, text=MEDICAL_APP_NAME + " Application", command=self.askForDepth)
        self.appFrame.boutonAppJouet = Radiobutton(self.appFrame, variable=self.valueBtnApp, value=TOY_ID, text=TOY_APP_NAME + " Application", command=self.askForDepth)
        self.appFrame.boutonAppFiveHB = Radiobutton(self.appFrame, variable=self.valueBtnApp, value=FIVEHB_ID, text=FIVEHB_APP_NAME + " Application", command=self.askForDepth)
        self.appFrame.boutonAppCroissant = Radiobutton(self.appFrame, variable=self.valueBtnApp, value=CROISSANT_ID, text=CROISSANT_APP_NAME + " Application", command=self.askForDepth)
        self.appFrame.boutonAppMed.grid(row=fromRow, column=1, columnspan=7)
        self.appFrame.boutonAppJouet.grid(row=fromRow+1, column=1, columnspan=7)
        self.appFrame.boutonAppFiveHB.grid(row=fromRow+2, column=1, columnspan=7)
        self.appFrame.boutonAppCroissant.grid(row=fromRow+3, column=1, columnspan=7)

    def showExecOrAnalysis(self, fromRow) :
        self.analyzeFrame.boutonExec    = Radiobutton(self.analyzeFrame, variable=self.valueBtnExecOrAnalysis, value=EXECUTION_ID, text="Execution", command=self.changeAnalysisLabel)
        self.analyzeFrame.boutonComp    = Radiobutton(self.analyzeFrame, variable=self.valueBtnExecOrAnalysis, value=COMPLEXITY_ANALYSIS_ID, text="Complexity analysis", command=self.changeAnalysisLabel)
        self.analyzeFrame.boutonMem     = Radiobutton(self.analyzeFrame, variable=self.valueBtnExecOrAnalysis, value=MEMORY_ANALYSIS_ID, text="Memory cost analysis", command=self.changeAnalysisLabel)
        self.analyzeFrame.boutonExplo   = Radiobutton(self.analyzeFrame, variable=self.valueBtnExecOrAnalysis, value=EXPLORATION_ID, text="Exploration", command=self.changeAnalysisLabel)
        self.analyzeFrame.boutonExec.grid(row=fromRow, column=1, columnspan=2)
        self.analyzeFrame.boutonComp.grid(row=fromRow+1, column=1, columnspan=2)
        self.analyzeFrame.boutonMem.grid(row=fromRow+2, column=1, columnspan=2)
        self.analyzeFrame.boutonExplo.grid(row=fromRow+3, column=1, columnspan=2)

    def showGraphs(self) :
        if self.valueBtnExecOrAnalysis.get() == str(EXPLORATION_ID) :
            appli = self.valueBtnApp.get()
            popupGraph = GraphInterface("explo_Appli" + getApplicationName(appli)+"_graph")
            popupGraph.show()
        else :
            for graph in self.graphsName :
                popupGraph = GraphInterface(graph)
                popupGraph.show()

    def updateNbOfRow(self, scheme) :
        self.nbOfRow = self.nbOfRow + 1 #Name of the scheme
        self.nbOfRow = self.nbOfRow + 2*len(scheme.params) #2 lines by param

    def showSchemeSelection(self) :
        self.scheme_text.grid(row=1, column=1)
        fromRow = 3
        for scheme in self.schemeList :
            scheme.checkButton.grid(row=fromRow, column=1)
            fromRow = fromRow + 1

    def changeAnalysisLabel(self) :
        self.startAnalyzeButton.grid_forget()
        self.analyzeConfirmation.grid_forget()
        self.showGraphButton.grid_forget()
        self.security.grid_forget()
        self.bouton80.grid_forget()
        self.bouton128.grid_forget()
        self.depth.grid_forget()
        self.depthVar.forgetAll()
        self.depthVarValid.grid_forget()
        self.exploType.grid_forget()
        self.exploTypeComp.grid_forget()
        self.exploTypeMem.grid_forget()
        self.exploTypeCompromise.grid_forget()
        self.options.grid_forget()
        self.compMaxLabel.grid_forget()
        self.compMaxValue.grid_forget()
        self.memMaxLabel.grid_forget()
        self.memMaxValue.grid_forget()
        self.exploRecap.grid_forget()
        self.depthButton.grid_forget()
        self.depthLabel.grid_forget()

        if self.valueBtnExecOrAnalysis.get() == str(EXECUTION_ID) :
            self.labelVar.set("Nothing to execute.")
            self.defaultValues(0)
        elif self.valueBtnExecOrAnalysis.get() == str(EXPLORATION_ID) :
            self.exploType.grid(row=7, column=1, columnspan=2)
            self.exploTypeComp.grid(row=8, column=1, columnspan=2)
            self.exploTypeMem.grid(row=9, column=1, columnspan=2)
            self.exploTypeCompromise.grid(row=10, column=1, columnspan=2)

            self.options.grid(row=11, column=1, columnspan=2)

            self.compMaxLabel.grid(row=12, column=1)
            self.compMaxValue.grid(row=12, column=2)

            self.memMaxLabel.grid(row=13, column=1)
            self.memMaxValue.grid(row=13, column=2)

            if self.valueBtnApp.get() == "" :
                self.labelVar.set("No application to explore.")
            else :
                self.askForDepth()
        else :
            self.defaultValues(0)
            self.labelVar.set("Nothing to analyze.")

    def askForDepth(self) :
        self.startAnalyzeButton.grid_forget()
        self.analyzeConfirmation.grid_forget()
        self.showGraphButton.grid_forget()
        self.security.grid_forget()
        self.bouton80.grid_forget()
        self.bouton128.grid_forget()
        self.depth.grid_forget()
        self.depthVar.forgetAll()
        self.depthVarValid.grid_forget()
        self.exploRecap.grid_forget()
        self.depthButton.grid_forget()
        self.depthLabel.grid_forget()

        if self.valueBtnExecOrAnalysis.get() == str(EXPLORATION_ID) :
            self.security.grid(row=6+0, column=1, sticky=N+E+W+S, columnspan=7)
            self.bouton80.grid(row=6+1, column=1, sticky=N+E+W+S, columnspan=7)
            self.bouton128.grid(row=6+2, column=1, sticky=N+E+W+S, columnspan=7)

            self.depth.grid(row=6+3, column=1, sticky=N+E+W+S, columnspan=7)
            self.depthVar.showVariation(6+4)
            self.depthVarValid.grid(row=6+5, column=1, sticky=N+E+W+S, columnspan=7)

            self.depthVar.minInt.set(getApplicationDepth(self.valueBtnApp.get()))
            self.depthVar.maxInt.set(getApplicationDepth(self.valueBtnApp.get()))

        elif self.valueBtnExecOrAnalysis.get() == str(EXECUTION_ID) :
            self.labelVar.set("Nothing to execute.")

        else :
            self.labelVar.set("Nothing to analyze.")

fenetre = Tk()
fenetre.title("PAnTHErS")
interface = Interface(fenetre)

interface.mainloop()

print("PAnTHErS exiting")
