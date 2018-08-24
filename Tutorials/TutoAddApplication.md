# Adding a new Homomorphic application to PAnTHErS

PAnTHErS is provided with some applications. They show some examples of how it is possible to evaluate homomorphic encryption usage. You can also integrate your own application within PAnTHErS with a few steps described in this tutorial.

[TOC]

## Write your Application code and convert it to PAnTHErS format.

You first need to get your own application working, written in C++,  using [Cingulata](https://github.com/CEA-LIST/Cingulata) tool. 

Then convert your application to BLIF format. A detailed example of application convertion to BLIF is presented on [Cingulata website](https://github.com/CEA-LIST/Cingulata/wiki/tutorial_hello).

From your converted BLIF file, convert it using PAnTHErS embedded tool.
The convertion tool is located on `/path/to/panthers/Templates/Template_Appli/Tools`.

To convert your application you need:
* `parse_mapped_blif.rb`: The convertion tool, written in Ruby. 
* `appli.blif`: Your application, converted to BLIF format using [Cingulata](https://github.com/CEA-LIST/Cingulata).

From a terminal, run PAnTHErS convertion tool. Here is an example of convertion for a sample `appli.blif` file:

```bash
$> ./parse_mapped_blif.rb -i appli.blif -o appli.sage
Module "CIRCUIT"
 Inputs:      8
 Outputs:     8
 Gates:      94
  buf:        1
  inv:       27
  and:       14
  xor:       53
$>
```

The tool will create a file called `appli.sage`, containing your converted application.

Here is an example of the content for a sample `appli.sage` file:
```
i_2 = ENC(i_2_input);
i_3 = ENC(i_3_input);
i_4 = ENC(i_4_input);
i_5 = ENC(i_5_input);
i_6 = ENC(i_6_input);
i_7 = ENC(i_7_input);
i_8 = ENC(i_8_input);
i_9 = ENC(i_9_input);

m_6 = XOR(i_9, i_8);
n106 = NOT(i_9);
n104 = NOT(i_8);
n20 = AND(i_9, i_8);
n22 = NOT(i_7);
m_7 = i_9;
n40 = NOT(i_5);
n19 = NOT(i_3);
...
```

Keep your `appli.sage` file for later PAnTHErS application integration steps.

## Add your application code to PAnTHErS

### Get application template files
Get 2 template files from `/path/to/panthers/Templates/Template_Appli`:
* appli_TOREPLACE.py
* exec_TOREPLACE.py

Copy them to `/path/to/panthers/Analyse` and rename it with your app name.

Here is an example for a sample application named `MyApp`.
```bash
$> cd /path/to/panthers
$> cp Templates/Template_Appli/appli_TOREPLACE.py Analyse/appli_MyApp.py
$> cp Templates/Template_Appli/exec_TOREPLACE.py Analyse/exec_MyApp.py
```

Edit the code from the new created files.

First edit the file `appli_MyApp.py` and `exec_MyApp.py`, replace every instance of the string `TOREPLACE` with the name of your application. You can do it using the following `sed` command:

```bash
$> cd /path/to/panthers/Analyse
$> sed -i 's/TOREPLACE/MyApp/g' appli_MyApp.py exec_MyApp.py
```
### Create a global identifier for your application

Edit the file `const_id.py`, and add a global identifier for your application. 
>:warning: Beware not to choose an identifier already affected to an existing application. It is recommended to use the value of the highest known application ID and increment it by one for your own application ID.
>

For example, for the application `MyApp`, create a new global identifier called `MYAPP_ID`:

```python
MYAPP_ID = 5
```

Also, you have to update the constant `MAX_APP_ID`. Its value must be equal to one above the maximum application ID value.

For example, for the application `MyApp`, as we added one identifier,  the `MAX_APP_ID` as to be updated :

```python
MAX_APP_ID = 5
#BECOMES
MAX_APP_ID = 6
```

Update the `getApplicationName` function. This function is used to easily retrieve the application name from its global identifier value.

Here is an example for the application `MyApp`.
```python
    elif appId == MYAPP_ID :
        return MYAPP_APP_NAME
```

Update the `getApplicationDepth` function. This function is used to easily retrieve the application multiplicative depth from its global identifier value.

Here is an example for the application `MyApp`.
```python
    elif appliName == MYAPP_APP_NAME:
        return 2
```

Here is a full example of the `const_id.py` file after adding a global identifier for the application`MyApp`:

```python
#SCHEMES
FV_ID = 0
YASHE_ID = 1
FNTRU_ID = 2

#APPLICATIONS
MEDICAL_ID = 1
TOY_ID = 2
FIVEHB_ID = 3
CROISSANT_ID = 4
#ADD HERE THE NEW APPLICATION GLOBAL IDENTIFIER
MYAPP_ID = 5
#INVALID MODE, only here to now the max app id
#UPDATE THE MAX_APP_ID VALUE TO FIT THE MAX APP_ID VALUE +1
MAX_APP_ID = 6

#APPLICATION NAMES
MEDICAL_APP_NAME = "Medical"
TOY_APP_NAME = "Toy"
FIVEHB_APP_NAME = "FiveHB"
CROISSANT_APP_NAME = "Croissant"
#Add MyApp application name
MYAPP_APP_NAME = "MyApp"

#ANALYSIS_MODES / EXPLORATION_MODES
ANALYZE_ID = 0
EXPLORATION_ID = 1

EXECUTION_ID = 1
COMPLEXITY_ANALYSIS_ID = 2
MEMORY_ANALYSIS_ID = 3
EXPLORATION_ID = 4
#INVALID MODE, only here to know the max mode value
MAX_MODE_ID = 5

def getApplicationName(appli) :
    #...
    elif appli == MYAPP_ID :
        appliName = MYAPP_APP_NAME
    else :
        raise Exception("getApplicationName: appli of ID {} is not in PAnTHErS library".format(scheme))
    return appliName

#...
def getApplicationDepth(appli) :
    #...
    elif appliName == MYAPP_APP_NAME :
        depth = 6
    return depth
```

### Update the templates with your application global identifier

Edit the template files `appli_MyApp.py` and replace the occurences of `APPNUMBER_ID` with your application identifier.

```bash
$> cd /path/to/panthers/Analyse
$> sed -i 's/APPNUMBER_ID/MYAPP_ID/g' appli_MyApp.py
```

### Integrate your application code in the template

Edit the file `appli_MyApp.py` and paste your converted application code from the file `appli.sage` at the end of the function named `computeApplicationMyApp`, between the `KEYGEN()` function call and the `return` statement.

```python
KEYGEN()
#PASTE YOUR CODE HERE
return
```

Before the code of your application, you need to assign all inputs parameters. For the example application the following line is used:

```python
[i_2_input, i_3_input, i_4_input, i_5_input, i_6_input, i_7_input, i_8_input, i_9_input] = plaintexts
```

At the end of the application code, the outputs also need to be gathered to be returned from the function. For this example application, the following lines are used:

```python
#aggregate bits in one byte
    res = int(R2(m_0_output.value))*128 + int(R2(m_1_output.value))*64 + int(R2(m_2_output.value))*32 + int(R2(m_3_output.value))*16 + int(R2(m_4_output.value))*8 + int(R2(m_5_output.value))*4 + int(R2(m_6_output.value))*2 + int(R2(m_7_output.value))
    
    #return decrypted byte
    return res
```

Here is an extract of the resulting `computeApplicationMyApp` for the `MyApp` application:

```python
def computeApplicationMyApp(scheme, plaintexts, R, progressBar = 0, step = 0) :
	#...
    KEYGEN()
    #PASTE YOUR APPLICATION CODE HERE
    #Add the list of your input parameters here
    [i_2_input, i_3_input, i_4_input, i_5_input, i_6_input, i_7_input, i_8_input, i_9_input] = plaintexts
    
    i_2 = ENC(i_2_input);
    i_3 = ENC(i_3_input);
    i_4 = ENC(i_4_input);
    i_5 = ENC(i_5_input);
    i_6 = ENC(i_6_input);
    i_7 = ENC(i_7_input);
    i_8 = ENC(i_8_input);
    i_9 = ENC(i_9_input);

    m_6 = XOR(i_9, i_8);
    n106 = NOT(i_9);
    n104 = NOT(i_8);
    n20 = AND(i_9, i_8);
    n22 = NOT(i_7);
    m_7 = i_9;
    n40 = NOT(i_5);
    n19 = NOT(i_3);
    #...
    
    #decrypt each encrypted bit
    m_0_output = DEC(m_0);
    m_1_output = DEC(m_1);
    m_2_output = DEC(m_2);
    m_3_output = DEC(m_3);
    m_4_output = DEC(m_4);
    m_5_output = DEC(m_5);
    m_6_output = DEC(m_6);
    m_7_output = DEC(m_7);
    #Return your application outputs 
    
    #aggregate bits in one byte
    res = int(R2(m_0_output.value))*128 + int(R2(m_1_output.value))*64 + int(R2(m_2_output.value))*32 + int(R2(m_3_output.value))*16 + int(R2(m_4_output.value))*8 + int(R2(m_5_output.value))*4 + int(R2(m_6_output.value))*2 + int(R2(m_7_output.value))
    
    #return decrypted byte
    return res
```

### Create your application input parameters

Then you need to provide plaintext input for your application. The function `setPlaintextsAppliMyApp` is responsible for generating plaintext input, and store them in a list called `plaintexts`.

> :bulb: Cingulata converted application usually takes input parameters split in single bits.
>

> :warning: Take care of the order of the output parameters. The order as to be the same as used when you retrieve the parameters in the function `computeApplicationMyApp`.
>

In this example, the function takes input parameters and split them in single bits:

```python
#Here the application input takes a single integer value
def setPlaintextsAppliMyApp(intInputValue) :
    #Here the integer value is split in single bit values
    plaintexts = Integer(intInputValue).digits(2, padto = 8)
    plaintexts.reverse()
    #return the list of bits
    return plaintexts
```

> :bulb: **Optional**: The input parameters are then processed by the `createSchemeWithPlaintextsAppliMyAppli` function to convert them to `HEMessage` objects. The code provided in the template can usually be reused for Cingulata converted applications. If not, you can edit it manually to fit your application needs.
>

> :bulb: You can see other application examples from applications already integrated in PAnTHErS (files named `appli_*.py`).
>


## Add your application to PAnTHErS graphical interface

### Get the template file

Copy the `TOREPLACEScript.sagescript` template file located in `Templates/Template_Appl`, rename it with your application name and put it in the `Interface` folder.

Here is an example for the sample application `MyApp`:

```bash
$> cd /path/to/panthers
$> cp Templates/Template_Appli/TOREPLACEScript.sagescript Interface/MyAppScript.sagescript
```

Edit the newly created `MyAppScript.sagescript` file, and replace all instances of `TOREPLACE` with your app name.

Here is an example for the sample application `MyApp` using a single `sed` command

```bash
$> sed -i 's/TOREPLACE/MyApp/g' MyAppScript.sagescript
```

### Update graphical interface source files

#### `Analyse/parameterchoice.sage` file

In the `parameterchoice.sage` file, update the `executePracticalAnalysis` function.

Add a `elif` statement matching your application global identifier. The purpose of this function is to launch the application analysis process.

Here is an example for the sample application `MyApp`:
```python
    elif appli == MYAPP_ID  :
        print("executePracticalAnalysis : MyApp")
        out = check_output(["sage", "-c", "os.system('sage < MyAppScript.sagescript')"])
```

#### `Interface/interface.py` file

Update the `showApp` function. The purpose of this function is to create graphical elements for the graphical interface (buttons, labels,...).

You have to add some lines of code to add buttons for your application.

Here is an example for the sample application `MyApp`:

```python
    #Create a radio button for MyApp
    self.appFrame.boutonAppMyApp = Radiobutton(self.appFrame, variable=self.valueBtnApp, value=MYAPP_ID, text=MYAPP_APP_NAME+" Application", command=self.askForDepth)
    #Position the new button on the interface
    self.appFrame.boutonAppMyApp.grid(row=fromRow+MYAPP_ID-1, column=1, columnspan=7)
```

#### `Analyse/analyse.py` file

At the beginning of the `analyse.py` file, add an `attach` statement to load your application.

The statement for the application `MyApp` should be:
```python
attach("../Analyse/appli_MyApp.py")
```

Next, update the `bench` function. Add a new `elif` statement to allow starting new analysis for your application.

Here is the resulting code for the `MyApp` application.
```python
    #If MyApp is selected
    elif appli == MYAPP_ID :
        print(MYAPP_APP_NAME)
        #Start MyApp
        graphsName = appliMyApp(execOrAnalyse, scheme, params, progressBar)
```

Update the `panthersAppli` function. You need to add a new `elif` statement matching your application global identifier. The added code is responsible for starting the analysis and retrieving the results.

Here is the resulting code for the `MyApp` application:
```python
    #MyApp is selected
    elif appli == MYAPP_ID :
        #Start complexity analysis for MyApp
        setParam.compPanthers = panthersAppliMyAppOnce(scheme, schemeParams, COMPLEXITY_ANALYSIS_ID, fileComp, setParam.depth)
        #Start memory cost analysis for MyApp
        setParam.memPanthers = panthersAppliMyAppOnce(scheme, schemeParams, MEMORY_ANALYSIS_ID, fileMem, setParam.depth)
        #If an execution is required
        if execOrAnalyze == EXECUTION_ID :
            #Start a practical execution of MyApp
            setParam.memCalibrated, setParam.compCalibrated = executePracticalAnalysis(appli, EXPLORATION_ID, "MiB_mem_tmp", scheme, schemeParams)
```






This file is distributed under the [CeCILL 2.1 License](http://www.cecill.info).
See the License.txt file for more details.

© 2018 Cyrielle Feron - ENSTA Bretagne



