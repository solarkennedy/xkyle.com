(* Content-type: application/mathematica *)

(*** Wolfram Notebook File ***)
(* http://www.wolfram.com/nb *)

(* CreatedBy='Mathematica 6.0' *)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[       145,          7]
NotebookDataLength[     51886,       1211]
NotebookOptionsPosition[     35151,        911]
NotebookOutlinePosition[     51760,       1208]
CellTagsIndexPosition[     51717,       1205]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{
Cell[BoxData[{
 RowBox[{"<<", "DiscreteWavelets`DiscreteWavelets`"}], "\n", 
 RowBox[{
  RowBox[{"Transform", "[", "Input_", "]"}], ":=", 
  RowBox[{"Module", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"Output", ",", "w", ",", "i"}], "}"}], ",", 
    RowBox[{
     RowBox[{"i", "=", "3"}], ";", "\[IndentingNewLine]", 
     RowBox[{"(*", " ", 
      RowBox[{
      "This", " ", "is", " ", "the", " ", "HWT", " ", "that", " ", "takes", 
       " ", "in", " ", "a", " ", "matrix", " ", "and", " ", "spits", " ", 
       "the", " ", "blur", " ", "out"}], " ", "*)"}], "\[IndentingNewLine]", 
     RowBox[{"w", "=", 
      RowBox[{"80", "/", 
       RowBox[{"(", 
        RowBox[{"2", "^", "i"}], ")"}]}]}], ";", "\[IndentingNewLine]", 
     RowBox[{"Output", "=", 
      RowBox[{
       RowBox[{"HWT2D", "[", 
        RowBox[{
         RowBox[{"N", "[", "Input", "]"}], ",", 
         RowBox[{"NumIterations", "\[Rule]", "i"}]}], "]"}], "[", 
       RowBox[{"[", 
        RowBox[{
         RowBox[{"1", ";;", "w"}], ",", 
         RowBox[{"1", ";;", "w"}]}], "]"}], "]"}]}]}]}], "]"}]}], "\n", 
 RowBox[{
  RowBox[{
   RowBox[{"Pad", "[", "L_", "]"}], ":=", 
   RowBox[{"Module", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"WF", ",", "HF", ",", "WL1", ",", "L1"}], "}"}], ",", 
     RowBox[{
      RowBox[{"WF", ":=", 
       RowBox[{"ConstantArray", "[", 
        RowBox[{"255", ",", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{
            RowBox[{"Dimensions", "[", "L", "]"}], "[", 
            RowBox[{"[", "1", "]"}], "]"}], ",", 
           RowBox[{"80", "-", 
            RowBox[{
             RowBox[{"Dimensions", "[", "L", "]"}], "[", 
             RowBox[{"[", "2", "]"}], "]"}]}]}], "}"}]}], "]"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"(*", " ", 
       RowBox[{
        RowBox[{
        "This", " ", "function", " ", "takes", " ", "in", " ", "a", " ", 
         "matrix", " ", "and", " ", "returns", " ", "a", " ", "standard", " ",
          "80", "x80", " ", "matrix"}], ",", " ", 
        RowBox[{
        "they", " ", "all", " ", "have", " ", "to", " ", "be", " ", "the", 
         " ", "same", " ", "size"}]}], " ", "*)"}], "\[IndentingNewLine]", 
      RowBox[{"HF", ":=", 
       RowBox[{"ConstantArray", "[", 
        RowBox[{"255", ",", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"80", "-", 
            RowBox[{
             RowBox[{"Dimensions", "[", "L", "]"}], "[", 
             RowBox[{"[", "1", "]"}], "]"}]}], ",", "80"}], "}"}]}], "]"}]}], 
      ";", "\[IndentingNewLine]", 
      RowBox[{"WL1", ":=", 
       RowBox[{"Join", "[", 
        RowBox[{"L", ",", "WF", ",", "2"}], "]"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"L1", ":=", 
       RowBox[{"ArrayFlatten", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", "WL1", "}"}], ",", 
          RowBox[{"{", "HF", "}"}]}], "}"}], "]"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"Return", "[", "L1", "]"}], ";"}]}], "]"}]}], "\n"}], "\n", 
 RowBox[{
  RowBox[{
   RowBox[{"GenerateCaptcha", "[", "]"}], ":=", 
   RowBox[{"Module", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
      "FullString", ",", "i", ",", "RotateAngle", ",", "RandomLocation", ",", 
       "CAPTCHA", ",", "pgmout", ",", "Data"}], "}"}], ",", 
     "\[IndentingNewLine]", 
     RowBox[{"(*", " ", 
      RowBox[{
      "This", " ", "function", " ", "generates", " ", "the", " ", "captcha", 
       " ", "and", " ", "returns", " ", "the", " ", "matrix", " ", "of", " ", 
       "it"}], " ", "*)"}], "\[IndentingNewLine]", 
     RowBox[{
      RowBox[{
      "FullString", "=", "\"\<ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890\>\""}], 
      ";", "\[IndentingNewLine]", 
      RowBox[{"FullString", "=", "\"\<IVXCDLM0123456789\>\""}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"(*", " ", 
       RowBox[{
       "We", " ", "are", " ", "using", " ", "a", " ", "reduced", " ", "set", 
        " ", "of", " ", "letters", " ", "per", " ", "the", " ", "paper"}], 
       " ", "*)"}], "\[IndentingNewLine]", 
      RowBox[{"RandomString", "=", "\"\<\>\""}], ";", "\[IndentingNewLine]", 
      RowBox[{"For", "[", 
       RowBox[{
        RowBox[{"i", "=", "1"}], ",", 
        RowBox[{"i", "<", "6"}], ",", 
        RowBox[{"i", "++"}], ",", 
        RowBox[{"RandomString", "=", 
         RowBox[{"StringJoin", "[", 
          RowBox[{
           RowBox[{"StringTake", "[", 
            RowBox[{"FullString", ",", 
             RowBox[{"{", 
              RowBox[{"RandomInteger", "[", 
               RowBox[{"{", 
                RowBox[{"1", ",", "17"}], "}"}], "]"}], "}"}]}], "]"}], ",", 
           "RandomString"}], "]"}]}]}], "]"}], ";", "\[IndentingNewLine]", 
      RowBox[{"RotateAngle", "=", 
       RowBox[{"RandomInteger", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"-", "10"}], ",", "10"}], "}"}], "]"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"RandomLocation", "=", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"RandomInteger", "[", 
          RowBox[{"{", 
           RowBox[{"100", ",", "500"}], "}"}], "]"}], ",", 
         RowBox[{"RandomInteger", "[", 
          RowBox[{"{", 
           RowBox[{"60", ",", "150"}], "}"}], "]"}]}], "}"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"CAPTCHA", "=", 
       RowBox[{"Graphics", "[", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{
           RowBox[{"Rotate", "[", 
            RowBox[{
             RowBox[{"Inset", "[", 
              RowBox[{
               RowBox[{"Text", "[", 
                RowBox[{"Style", "[", 
                 RowBox[{"RandomString", ",", 
                  RowBox[{"FontSize", "\[Rule]", "40"}], ",", 
                  RowBox[{"FontWeight", "\[Rule]", "\"\<Bold\>\""}], ",", 
                  "Gray", ",", 
                  RowBox[{"FontFamily", "\[Rule]", "\"\<Helvetica\>\""}]}], 
                 "]"}], "]"}], ",", "RandomLocation"}], "]"}], ",", 
             RowBox[{"RotateAngle", " ", "Degree"}]}], "]"}], ",", 
           RowBox[{"Opacity", "[", "0", "]"}], ",", 
           RowBox[{"Rectangle", "[", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"0", ",", "0"}], "}"}], ",", 
             RowBox[{"{", 
              RowBox[{"600", ",", "200"}], "}"}]}], "]"}]}], "}"}], ",", 
         RowBox[{"GridLines", "\[Rule]", 
          RowBox[{"{", 
           RowBox[{
            RowBox[{"Table", "[", 
             RowBox[{"i", ",", 
              RowBox[{"{", 
               RowBox[{"i", ",", "0", ",", "600", ",", "25"}], "}"}]}], "]"}],
             ",", 
            RowBox[{"Table", "[", 
             RowBox[{"i", ",", 
              RowBox[{"{", 
               RowBox[{"i", ",", "0", ",", "200", ",", "25"}], "}"}]}], 
             "]"}]}], "}"}]}], ",", 
         RowBox[{"GridLinesStyle", "\[Rule]", 
          RowBox[{"Directive", "[", "Black", "]"}]}]}], "]"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"Export", "[", 
       RowBox[{"\"\<out.gif\>\"", ",", "CAPTCHA", ",", "\"\<GIF\>\""}], "]"}],
       ";", "\[IndentingNewLine]", 
      RowBox[{"pgmout", ":=", 
       RowBox[{"Import", "[", "\"\<out.gif\>\"", "]"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"Export", "[", 
       RowBox[{"\"\<out.pgm\>\"", ",", "pgmout", ",", "\"\<PGM\>\""}], "]"}], 
      ";", "\[IndentingNewLine]", 
      RowBox[{"Data", "=", 
       RowBox[{"Import", "[", 
        RowBox[{"\"\<out.pgm\>\"", ",", "\"\<Data\>\""}], "]"}]}], ";", 
      "\[IndentingNewLine]", "Data"}]}], "]"}]}], "\n", 
  "\[IndentingNewLine]"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"Unset", "[", "Cannon", "]"}], ";"}], "\n", 
 RowBox[{
  RowBox[{"AllLetters", "=", "\"\<ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890\>\""}],
   ";"}], "\n", 
 RowBox[{
  RowBox[{"AllLetters", "=", "\"\<IVXCDLM0123456789\>\""}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"For", "[", 
  RowBox[{
   RowBox[{"i", "=", "1"}], ",", 
   RowBox[{"i", "\[LessEqual]", 
    RowBox[{"StringLength", "[", "AllLetters", "]"}]}], ",", 
   RowBox[{"i", "++"}], ",", 
   RowBox[{
    RowBox[{"Letter", "=", 
     RowBox[{"StringTake", "[", 
      RowBox[{"AllLetters", ",", 
       RowBox[{"{", "i", "}"}]}], "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{
     "For", " ", "each", " ", "letter", " ", "generate", " ", "a", " ", 
      "Canonical", " ", "matrix", " ", "for", " ", "it"}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{
     RowBox[{"LetterArray", "[", "i", "]"}], "=", "Letter"}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"G1", "=", 
     RowBox[{"Graphics", "[", 
      RowBox[{
       RowBox[{"Text", "[", 
        RowBox[{
         RowBox[{"Style", "[", 
          RowBox[{"Letter", ",", "Gray", ",", 
           RowBox[{"FontSize", "\[Rule]", "40"}], ",", 
           RowBox[{"FontWeight", "\[Rule]", "\"\<Bold\>\""}], ",", 
           RowBox[{"FontFamily", "\[Rule]", "\"\<Helvetica\>\""}]}], "]"}], 
         ",", 
         RowBox[{"Background", "\[Rule]", "White"}]}], "]"}], ",", 
       RowBox[{"AspectRatio", "\[Rule]", "Automatic"}], ",", 
       RowBox[{"ImageSize", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{"40", ",", "40"}], "}"}]}]}], "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"Export", "[", 
     RowBox[{"\"\<Letter.pgm\>\"", ",", "G1", ",", "\"\<PGM\>\""}], "]"}], 
    ";", "\[IndentingNewLine]", 
    RowBox[{"ImageData", "=", 
     RowBox[{"Import", "[", 
      RowBox[{"\"\<Letter.pgm\>\"", ",", "\"\<Data\>\""}], "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"I1", "=", 
     RowBox[{"Position", "[", 
      RowBox[{"ImageData", ",", "127"}], "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"I1", "=", 
     RowBox[{"I1", ".", 
      RowBox[{"RotationMatrix", "[", 
       RowBox[{"Pi", "/", "2"}], "]"}]}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"Width", "=", 
     RowBox[{"Ceiling", "[", 
      RowBox[{
       RowBox[{"Max", "[", 
        RowBox[{"I1", "[", 
         RowBox[{"[", 
          RowBox[{"All", ",", "1"}], "]"}], "]"}], "]"}], "-", 
       RowBox[{"Min", "[", 
        RowBox[{"I1", "[", 
         RowBox[{"[", 
          RowBox[{"All", ",", "1"}], "]"}], "]"}], "]"}]}], "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"Height", "=", 
     RowBox[{"Ceiling", "[", 
      RowBox[{
       RowBox[{"Max", "[", 
        RowBox[{"I1", "[", 
         RowBox[{"[", 
          RowBox[{"All", ",", "2"}], "]"}], "]"}], "]"}], "-", 
       RowBox[{"Min", "[", 
        RowBox[{"I1", "[", 
         RowBox[{"[", 
          RowBox[{"All", ",", "2"}], "]"}], "]"}], "]"}]}], "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"G2", "=", 
     RowBox[{"ListPlot", "[", 
      RowBox[{
       RowBox[{"Round", "[", "I1", "]"}], ",", 
       RowBox[{"Axes", "\[Rule]", "False"}], ",", 
       RowBox[{"ImageSize", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"2", "*", "Width"}], ",", 
          RowBox[{"2", "*", "Height"}]}], "}"}]}], ",", 
       RowBox[{"AspectRatio", "\[Rule]", "Automatic"}]}], "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"Export", "[", 
     RowBox[{"\"\<G2.pgm\>\"", ",", "G2", ",", "\"\<PGM\>\""}], "]"}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"CroppedImageData", "=", 
     RowBox[{"Import", "[", 
      RowBox[{"\"\<G2.pgm\>\"", ",", "\"\<Data\>\""}], "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{
     RowBox[{"Cannon", "[", "i", "]"}], "=", 
     RowBox[{"Pad", "[", "CroppedImageData", "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{
     RowBox[{"TransformedCannon", "[", "i", "]"}], "=", 
     RowBox[{"Transform", "[", 
      RowBox[{"Pad", "[", "CroppedImageData", "]"}], "]"}]}], ";"}]}], 
  "]"}], "\n", 
 RowBox[{
  RowBox[{"Compare", "[", "Input_", "]"}], ":=", 
  RowBox[{"Module", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"i", ",", "Result", ",", "NORM", ",", "NormSoFar"}], "}"}], ",", 
    RowBox[{
     RowBox[{"NormSoFar", "=", "10000"}], ";", "\[IndentingNewLine]", 
     RowBox[{"(*", " ", 
      RowBox[{
       RowBox[{
       "This", " ", "function", " ", "takes", " ", "in", " ", "a", " ", 
        "matrix", " ", "and", " ", "compares", " ", "it", " ", "to", " ", 
        "all", " ", "the", " ", "letters"}], ",", " ", 
       RowBox[{
       "choosing", " ", "the", " ", "letter", " ", "with", " ", "the", " ", 
        "least", " ", "norm"}]}], " ", "*)"}], "\[IndentingNewLine]", 
     RowBox[{"Result", "=", "1"}], ";", "\[IndentingNewLine]", 
     RowBox[{"For", "[", 
      RowBox[{
       RowBox[{"i", "=", "1"}], ",", 
       RowBox[{"i", "\[LessEqual]", 
        RowBox[{"StringLength", "[", "AllLetters", "]"}]}], ",", 
       RowBox[{"i", "=", 
        RowBox[{"i", "+", "1"}]}], ",", 
       RowBox[{"(*", 
        RowBox[{
         RowBox[{"Compare", " ", "2"}], "-", 
         RowBox[{"norms", " ", "of", " ", "Matrix"}]}], "*)"}], 
       RowBox[{
        RowBox[{"NORM", "=", 
         RowBox[{"N", "[", 
          RowBox[{"Norm", "[", 
           RowBox[{
            RowBox[{"(", 
             RowBox[{
              RowBox[{"TransformedLetters", "[", "Input", "]"}], "-", 
              RowBox[{"TransformedCannon", "[", "i", "]"}]}], ")"}], ",", 
            "2"}], "]"}], "]"}]}], ";", "\[IndentingNewLine]", 
        RowBox[{"If", "[", 
         RowBox[{
          RowBox[{"(", 
           RowBox[{"NORM", "<", "NormSoFar"}], ")"}], ",", 
          RowBox[{
           RowBox[{"NormSoFar", "=", "NORM"}], ";", 
           RowBox[{"Result", "=", "i"}], ";"}]}], "]"}], ";"}]}], "]"}], ";", 
     "\[IndentingNewLine]", "Result"}]}], "]"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"AlignCaptcha", "[", "Matrix_", "]"}], ":=", 
  RowBox[{"Module", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{
     "Data", ",", "line", ",", "Rad", ",", "AlignedMatrix", ",", "Width", ",",
       "Height", ",", "CroppedImage"}], "}"}], ",", 
    RowBox[{
     RowBox[{"Data", "=", 
      RowBox[{"Position", "[", 
       RowBox[{"Matrix", ",", "127"}], "]"}]}], ";", "\[IndentingNewLine]", 
     RowBox[{"Data", "=", 
      RowBox[{"Data", ".", 
       RowBox[{"RotationMatrix", "[", 
        RowBox[{"Pi", "/", "2"}], "]"}]}]}], ";", "\[IndentingNewLine]", 
     RowBox[{"line", "=", 
      RowBox[{"Fit", "[", 
       RowBox[{"Data", ",", 
        RowBox[{"{", 
         RowBox[{"1", ",", "x"}], "}"}], ",", "x"}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"Rad", "=", 
      RowBox[{"ArcTan", "[", 
       RowBox[{
        RowBox[{"(", "line", ")"}], "[", 
        RowBox[{"[", 
         RowBox[{"2", ",", "1"}], "]"}], "]"}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"AlignedMatrix", "=", 
      RowBox[{"Data", ".", 
       RowBox[{"RotationMatrix", "[", "Rad", "]"}]}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"Width", "=", 
      RowBox[{"Ceiling", "[", 
       RowBox[{
        RowBox[{"Max", "[", 
         RowBox[{"AlignedMatrix", "[", 
          RowBox[{"[", 
           RowBox[{"All", ",", "1"}], "]"}], "]"}], "]"}], "-", 
        RowBox[{"Min", "[", 
         RowBox[{"AlignedMatrix", "[", 
          RowBox[{"[", 
           RowBox[{"All", ",", "1"}], "]"}], "]"}], "]"}]}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"Height", "=", 
      RowBox[{"Ceiling", "[", 
       RowBox[{
        RowBox[{"Max", "[", 
         RowBox[{"AlignedMatrix", "[", 
          RowBox[{"[", 
           RowBox[{"All", ",", "2"}], "]"}], "]"}], "]"}], "-", 
        RowBox[{"Min", "[", 
         RowBox[{"AlignedMatrix", "[", 
          RowBox[{"[", 
           RowBox[{"All", ",", "2"}], "]"}], "]"}], "]"}]}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"g", "=", 
      RowBox[{"ListPlot", "[", 
       RowBox[{"AlignedMatrix", ",", 
        RowBox[{"Axes", "\[Rule]", "False"}], ",", 
        RowBox[{"ImageSize", "\[Rule]", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"2", "*", "Width"}], ",", 
           RowBox[{"2", "*", "Height"}]}], "}"}]}], ",", 
        RowBox[{"AspectRatio", "\[Rule]", "Automatic"}]}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"Export", "[", 
      RowBox[{"\"\<out2.pgm\>\"", ",", "g", ",", "\"\<PGM\>\""}], "]"}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"CroppedImage", "=", 
      RowBox[{"Import", "[", 
       RowBox[{"\"\<out2.pgm\>\"", ",", "\"\<Data\>\""}], "]"}]}], ";", 
     "\[IndentingNewLine]", "CroppedImage"}]}], "]"}]}], "\n"}], "Input",
 CellChangeTimes->{{3.4500150733060427`*^9, 3.4500150935153036`*^9}, 
   3.4500151261525593`*^9, {3.4500151823038607`*^9, 3.4500152112457657`*^9}, 
   3.4500153343339853`*^9, {3.450015768402473*^9, 3.4500157686728644`*^9}, {
   3.450015988390994*^9, 3.4500160152999563`*^9}, 3.450093743638358*^9, 
   3.4500937935896864`*^9, 3.4500942373433475`*^9, {3.4500943812788815`*^9, 
   3.450094386476303*^9}, {3.4500945359297166`*^9, 3.4500945777093763`*^9}, {
   3.4500947774045324`*^9, 3.4500947777350044`*^9}, {3.4501734475000176`*^9, 
   3.450173621461897*^9}, {3.450174388933119*^9, 3.4501743901448736`*^9}, {
   3.450174482208172*^9, 3.450174499373025*^9}},
 FontSize->18],

Cell[BoxData[{
 RowBox[{
  RowBox[{"ImageData", "=", 
   RowBox[{"GenerateCaptcha", "[", "]"}]}], ";"}], "\n", 
 RowBox[{"ImagePlot", "[", "ImageData", "]"}], "\n", 
 RowBox[{
  RowBox[{"CroppedImageData", "=", 
   RowBox[{"AlignCaptcha", "[", "ImageData", "]"}]}], ";"}], "\n", 
 RowBox[{"ImagePlot", "[", "CroppedImageData", 
  "]"}], "\[IndentingNewLine]"}], "Input",
 CellChangeTimes->{{3.450015265694602*^9, 3.4500152659049063`*^9}},
 FontSize->18],

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", 
   RowBox[{
    RowBox[{
    "If", " ", "you", " ", "want", " ", "to", " ", "invert", " ", "it"}], ",", 
    RowBox[{
     RowBox[{
      RowBox[{"use", " ", "the", " ", "following", " ", 
       RowBox[{"line", ":", "CroppedImageData"}]}], "=", 
      RowBox[{
       RowBox[{"Mod", "[", 
        RowBox[{
         RowBox[{"CroppedImageData", "-", "255"}], ",", "255"}], "]"}], "^", 
       "2"}]}], ";"}]}], "*)"}], 
  RowBox[{
   RowBox[{
    RowBox[{
     RowBox[{"Dimensions", "[", "CroppedImageData", "]"}], "[", 
     RowBox[{"[", "2", "]"}], "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Columns", "=", 
     RowBox[{"{", "}"}]}], ";"}], "\n", 
   RowBox[{"For", "[", 
    RowBox[{
     RowBox[{"i", "=", "1"}], ",", 
     RowBox[{"i", "\[LessEqual]", 
      RowBox[{
       RowBox[{"Dimensions", "[", "CroppedImageData", "]"}], "[", 
       RowBox[{"[", "2", "]"}], "]"}]}], ",", 
     RowBox[{"i", "=", 
      RowBox[{"i", "+", "1"}]}], ",", 
     RowBox[{
      RowBox[{"DataColumn", "=", 
       RowBox[{"Mean", "[", 
        RowBox[{"CroppedImageData", "[", 
         RowBox[{"[", 
          RowBox[{"All", ",", "i"}], "]"}], "]"}], "]"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"If", "[", 
       RowBox[{
        RowBox[{"DataColumn", "\[Equal]", "255"}], ",", 
        RowBox[{"Columns", "=", 
         RowBox[{"Append", "[", 
          RowBox[{"Columns", ",", "i"}], "]"}]}]}], "]"}]}]}], "]"}], "\n", 
   RowBox[{"(*", 
    RowBox[{
     RowBox[{
     "We", " ", "need", " ", "this", " ", "extra", " ", "column", " ", "at", 
      " ", "the", " ", "end"}], ",", 
     RowBox[{
     "just", " ", "in", " ", "case", " ", "there", " ", "is", " ", "no", " ", 
      "whitespace", " ", "at", " ", "the", " ", "end"}]}], "*)"}], 
   "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"Columns", "=", 
     RowBox[{"Append", "[", 
      RowBox[{"Columns", ",", 
       RowBox[{
        RowBox[{"Dimensions", "[", "CroppedImageData", "]"}], "[", 
        RowBox[{"[", "2", "]"}], "]"}]}], "]"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Columns", "=", 
     RowBox[{
      RowBox[{"Tally", "[", "Columns", "]"}], "[", 
      RowBox[{"[", 
       RowBox[{"All", ",", "1"}], "]"}], "]"}]}], ";"}], "\n", 
   "\[IndentingNewLine]", 
   RowBox[{"Unset", "[", "Letters", "]"}], "\n", 
   RowBox[{
    RowBox[{"NewIndex", "=", "1"}], ";"}], "\n", 
   RowBox[{"For", "[", 
    RowBox[{
     RowBox[{"i", "=", "1"}], ",", 
     RowBox[{"i", "\[LessEqual]", 
      RowBox[{
       RowBox[{"Dimensions", "[", "Columns", "]"}], "[", 
       RowBox[{"[", "1", "]"}], "]"}]}], ",", 
     RowBox[{"i", "=", 
      RowBox[{"i", "+", "1"}]}], ",", 
     RowBox[{
      RowBox[{"BB", "=", 
       RowBox[{"Columns", "[", 
        RowBox[{"[", 
         RowBox[{"i", "-", "1"}], "]"}], "]"}]}], ";", "\[IndentingNewLine]", 
      RowBox[{"CC", "=", 
       RowBox[{"Columns", "[", 
        RowBox[{"[", "i", "]"}], "]"}]}], ";", "\[IndentingNewLine]", 
      RowBox[{"If", "[", 
       RowBox[{
        RowBox[{
         RowBox[{"BB", "+", "1"}], "\[NotEqual]", "CC"}], ",", 
        RowBox[{"(*", 
         RowBox[{
          RowBox[{"Print", "[", 
           RowBox[{
           "\"\<From \>\"", ",", "BB", ",", "\"\< to \>\"", ",", "CC", ",", 
            "\"\<  (Value \>\"", ",", "i", ",", "\"\<, NewIndex \>\"", ",", 
            "NewIndex", ",", "\"\<)\>\""}], "]"}], ";"}], "*)"}], 
        RowBox[{
         RowBox[{
          RowBox[{"Letters", "[", "NewIndex", "]"}], "=", 
          RowBox[{"Pad", "[", 
           RowBox[{"CroppedImageData", "[", 
            RowBox[{"[", 
             RowBox[{"All", ",", 
              RowBox[{"BB", ";;", "CC"}]}], "]"}], "]"}], "]"}]}], ";", 
         "\[IndentingNewLine]", 
         RowBox[{"NewIndex", "=", 
          RowBox[{"NewIndex", "+", "1"}]}], ";"}]}], "]"}]}]}], "]"}], 
   "\[IndentingNewLine]", "\n", 
   RowBox[{"(*", 
    RowBox[{
    "Loop", " ", "this", " ", "until", " ", "we", " ", "have", " ", "gotten", 
     " ", "to", " ", "the", " ", "end", " ", "of", " ", "the", " ", "image", 
     " ", "and", " ", "all", " ", "letters", " ", "are", " ", "cut"}], "*)"}],
    "\[IndentingNewLine]", 
   RowBox[{"For", "[", 
    RowBox[{
     RowBox[{"i", "=", "1"}], ",", 
     RowBox[{"i", "\[LessEqual]", "5"}], ",", 
     RowBox[{"i", "=", 
      RowBox[{"i", "+", "1"}]}], ",", 
     RowBox[{
      RowBox[{"Print", "[", 
       RowBox[{"ImagePlot", "[", 
        RowBox[{"Letters", "[", "i", "]"}], "]"}], "]"}], ";"}]}], "]"}], 
   "\n", "\[IndentingNewLine]"}]}]], "Input",
 CellChangeTimes->{
  3.4500150273695307`*^9, {3.4501732701031647`*^9, 3.450173271344962*^9}},
 FontSize->18],

Cell[BoxData[
 RowBox[{
  RowBox[{"For", "[", 
   RowBox[{
    RowBox[{"i", "=", "1"}], ",", 
    RowBox[{"i", "\[LessEqual]", "5"}], ",", 
    RowBox[{"i", "=", 
     RowBox[{"i", "+", "1"}]}], ",", "\[IndentingNewLine]", 
    RowBox[{
     RowBox[{
      RowBox[{"TransformedLetters", "[", "i", "]"}], "=", 
      RowBox[{"Transform", "[", 
       RowBox[{"Letters", "[", "i", "]"}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"p1", "=", 
      RowBox[{"ImagePlot", "[", 
       RowBox[{
        RowBox[{"Letters", "[", "i", "]"}], ",", 
        RowBox[{"PlotLabel", "->", "\"\<Original\>\""}]}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"B", "=", 
      RowBox[{"HWT2D", "[", 
       RowBox[{
        RowBox[{"N", "[", 
         RowBox[{"Letters", "[", "i", "]"}], "]"}], ",", 
        RowBox[{"NumIterations", "\[Rule]", "3"}]}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"p2", "=", 
      RowBox[{"WaveletDensityPlot", "[", 
       RowBox[{"B", ",", 
        RowBox[{"NumIterations", "\[Rule]", "3"}], ",", 
        RowBox[{"PlotLabel", "->", "\"\<HWT\>\""}]}], "]"}]}], ";", 
     "\[IndentingNewLine]", 
     RowBox[{"Print", "[", 
      RowBox[{"GraphicsGrid", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{"{", 
          RowBox[{"p1", ",", "p2"}], "}"}], "}"}], ",", 
        RowBox[{"Frame", "\[Rule]", "All"}]}], "]"}], "]"}], ";"}]}], 
   "\[IndentingNewLine]", "]"}], "\n"}]], "Input",
 CellChangeTimes->{{3.450015408180908*^9, 3.450015458834249*^9}, {
   3.4500155085061693`*^9, 3.4500155491550245`*^9}, {3.4500155942202744`*^9, 
   3.450015606147544*^9}, 3.450015642840672*^9, 3.450015698821727*^9, {
   3.4500921835005465`*^9, 3.4500921865849504`*^9}},
 FontSize->18],

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", 
   RowBox[{
   "Join", " ", "the", " ", "letters", " ", "together", " ", "and", " ", 
    "return", " ", "the", " ", "decoded", " ", "string"}], "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{"For", "[", 
    RowBox[{
     RowBox[{"i", "=", "1"}], ",", 
     RowBox[{"i", "\[LessEqual]", "5"}], ",", 
     RowBox[{"i", "=", 
      RowBox[{"i", "+", "1"}]}], ",", 
     RowBox[{
      RowBox[{
       RowBox[{"Answers", "[", "i", "]"}], "=", 
       RowBox[{"Compare", "[", "i", "]"}]}], ";", "\[IndentingNewLine]", 
      RowBox[{"Print", "[", 
       RowBox[{
        RowBox[{"StringTake", "[", 
         RowBox[{"RandomString", ",", 
          RowBox[{"{", "i", "}"}]}], "]"}], ",", "\"\< = \>\"", ",", 
        RowBox[{"LetterArray", "[", 
         RowBox[{"Answers", "[", "i", "]"}], "]"}]}], "]"}], ";"}]}], 
    "\[IndentingNewLine]", "]"}], "\n", 
   RowBox[{
    RowBox[{"TheAnswer", "=", "\"\<\>\""}], ";"}], "\n", 
   RowBox[{"For", "[", 
    RowBox[{
     RowBox[{"i", "=", "1"}], ",", 
     RowBox[{"i", "\[LessEqual]", "5"}], ",", 
     RowBox[{"i", "=", 
      RowBox[{"i", "+", "1"}]}], ",", 
     RowBox[{
      RowBox[{"Print", "[", 
       RowBox[{"ImagePlot", "[", 
        RowBox[{"Join", "[", 
         RowBox[{
          RowBox[{"Letters", "[", "i", "]"}], ",", 
          RowBox[{"Cannon", "[", 
           RowBox[{"Answers", "[", "i", "]"}], "]"}], ",", "2"}], "]"}], 
        "]"}], "]"}], ";", "\[IndentingNewLine]", 
      RowBox[{"TheAnswer", "=", 
       RowBox[{"StringJoin", "[", 
        RowBox[{"TheAnswer", ",", 
         RowBox[{"LetterArray", "[", 
          RowBox[{"Answers", "[", "i", "]"}], "]"}]}], "]"}]}], ";"}]}], 
    "]"}], "\n", 
   RowBox[{
    RowBox[{"Print", "[", 
     RowBox[{
     "\"\<Decoded Answer = \>\"", ",", "TheAnswer", ",", "\"\<\\n\>\"", ",", 
      "\"\<Real answer    = \>\"", ",", "RandomString"}], "]"}], ";"}], 
   "\n"}]}]], "Input",
 CellChangeTimes->{{3.450015706232457*^9, 3.450015736195841*^9}, 
   3.4500160422790194`*^9},
 FontSize->18],

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"Do", "[", " "}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{"NumberOfTimes", "=", "100"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"Counter", "=", "1"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"Correct", "=", "0"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{"While", "[", 
    RowBox[{
     RowBox[{"Counter", "\[LessEqual]", " ", "NumberOfTimes"}], ",", 
     "\[IndentingNewLine]", 
     RowBox[{
      RowBox[{"ImageData", "=", 
       RowBox[{"GenerateCaptcha", "[", "]"}]}], ";", "\[IndentingNewLine]", 
      RowBox[{"CroppedImageData", "=", 
       RowBox[{"AlignCaptcha", "[", "ImageData", "]"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{
       RowBox[{"ImagePlot", "[", "CroppedImageData", "]"}], 
       "\[IndentingNewLine]", 
       RowBox[{"Columns", "=", 
        RowBox[{"{", "}"}]}]}], ";", "\[IndentingNewLine]", 
      RowBox[{"For", "[", 
       RowBox[{
        RowBox[{"i", "=", "1"}], ",", 
        RowBox[{"i", "\[LessEqual]", 
         RowBox[{
          RowBox[{"Dimensions", "[", "CroppedImageData", "]"}], "[", 
          RowBox[{"[", "2", "]"}], "]"}]}], ",", 
        RowBox[{"i", "=", 
         RowBox[{"i", "+", "1"}]}], ",", 
        RowBox[{
         RowBox[{"DataColumn", "=", 
          RowBox[{"Mean", "[", 
           RowBox[{"CroppedImageData", "[", 
            RowBox[{"[", 
             RowBox[{"All", ",", "i"}], "]"}], "]"}], "]"}]}], ";", 
         "\[IndentingNewLine]", 
         RowBox[{"If", "[", 
          RowBox[{
           RowBox[{"DataColumn", "\[Equal]", "255"}], ",", 
           RowBox[{"Columns", "=", 
            RowBox[{"Append", "[", 
             RowBox[{"Columns", ",", "i"}], "]"}]}]}], "]"}]}]}], "]"}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"Columns", "=", 
       RowBox[{"Append", "[", 
        RowBox[{"Columns", ",", 
         RowBox[{
          RowBox[{"Dimensions", "[", "CroppedImageData", "]"}], "[", 
          RowBox[{"[", "2", "]"}], "]"}]}], "]"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"Columns", "=", 
       RowBox[{
        RowBox[{"Tally", "[", "Columns", "]"}], "[", 
        RowBox[{"[", 
         RowBox[{"All", ",", "1"}], "]"}], "]"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"Unset", "[", "Letters", "]"}], ";", "\[IndentingNewLine]", 
      RowBox[{"NewIndex", "=", "1"}], ";", "\[IndentingNewLine]", 
      RowBox[{"For", "[", 
       RowBox[{
        RowBox[{"i", "=", "1"}], ",", 
        RowBox[{"i", "\[LessEqual]", 
         RowBox[{
          RowBox[{"Dimensions", "[", "Columns", "]"}], "[", 
          RowBox[{"[", "1", "]"}], "]"}]}], ",", 
        RowBox[{"i", "=", 
         RowBox[{"i", "+", "1"}]}], ",", 
        RowBox[{
         RowBox[{"BB", "=", 
          RowBox[{"Columns", "[", 
           RowBox[{"[", 
            RowBox[{"i", "-", "1"}], "]"}], "]"}]}], ";", 
         "\[IndentingNewLine]", 
         RowBox[{"CC", "=", 
          RowBox[{"Columns", "[", 
           RowBox[{"[", "i", "]"}], "]"}]}], ";", "\[IndentingNewLine]", 
         RowBox[{"If", "[", 
          RowBox[{
           RowBox[{
            RowBox[{"BB", "+", "1"}], "\[NotEqual]", "CC"}], ",", 
           RowBox[{
            RowBox[{
             RowBox[{"Letters", "[", "NewIndex", "]"}], "=", 
             RowBox[{"Pad", "[", 
              RowBox[{"CroppedImageData", "[", 
               RowBox[{"[", 
                RowBox[{"All", ",", 
                 RowBox[{"BB", ";;", "CC"}]}], "]"}], "]"}], "]"}]}], ";", 
            "\[IndentingNewLine]", 
            RowBox[{"NewIndex", "=", 
             RowBox[{"NewIndex", "+", "1"}]}], ";"}]}], "]"}]}]}], "]"}], ";",
       "\[IndentingNewLine]", 
      RowBox[{"For", "[", 
       RowBox[{
        RowBox[{"i", "=", "1"}], ",", 
        RowBox[{"i", "\[LessEqual]", "5"}], ",", 
        RowBox[{"i", "=", 
         RowBox[{"i", "+", "1"}]}], ",", 
        RowBox[{
         RowBox[{
          RowBox[{"TransformedLetters", "[", "i", "]"}], "=", 
          RowBox[{"Transform", "[", 
           RowBox[{"Letters", "[", "i", "]"}], "]"}]}], ";"}]}], "]"}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{
       RowBox[{"For", "[", 
        RowBox[{
         RowBox[{"i", "=", "1"}], ",", 
         RowBox[{"i", "\[LessEqual]", "5"}], ",", 
         RowBox[{"i", "=", 
          RowBox[{"i", "+", "1"}]}], ",", 
         RowBox[{
          RowBox[{
           RowBox[{"Answers", "[", "i", "]"}], "=", 
           RowBox[{"Compare", "[", "i", "]"}]}], ";"}]}], 
        "\[IndentingNewLine]", 
        RowBox[{"(*", " ", 
         RowBox[{
          RowBox[{"Print", "[", 
           RowBox[{
            RowBox[{"StringTake", "[", 
             RowBox[{"RandomString", ",", 
              RowBox[{"{", "i", "}"}]}], "]"}], ",", "\"\< = \>\"", ",", 
            RowBox[{"LetterArray", "[", 
             RowBox[{"Answers", "[", "i", "]"}], "]"}]}], "]"}], ";"}], " ", 
         "*)"}], "\[IndentingNewLine]", "]"}], "\[IndentingNewLine]", 
       RowBox[{"Clear", "[", "TheAnswer", "]"}]}], ";", "\[IndentingNewLine]", 
      RowBox[{"TheAnswer", "=", "\"\<\>\""}], ";", "\[IndentingNewLine]", 
      RowBox[{"For", "[", 
       RowBox[{
        RowBox[{"i", "=", "1"}], ",", 
        RowBox[{"i", "\[LessEqual]", "5"}], ",", 
        RowBox[{"i", "=", 
         RowBox[{"i", "+", "1"}]}], ",", "\[IndentingNewLine]", 
        RowBox[{"(*", " ", 
         RowBox[{
          RowBox[{"Print", "[", 
           RowBox[{"ImagePlot", "[", 
            RowBox[{"Join", "[", 
             RowBox[{
              RowBox[{"Letters", "[", "i", "]"}], ",", 
              RowBox[{"Cannon", "[", 
               RowBox[{"Answers", "[", "i", "]"}], "]"}], ",", "2"}], "]"}], 
            "]"}], "]"}], ";"}], " ", "*)"}], "\[IndentingNewLine]", 
        RowBox[{
         RowBox[{"TheAnswer", "=", 
          RowBox[{"StringJoin", "[", 
           RowBox[{"TheAnswer", ",", 
            RowBox[{"LetterArray", "[", 
             RowBox[{"Answers", "[", "i", "]"}], "]"}]}], "]"}]}], ";"}]}], 
       "]"}], ";", "\n", 
      RowBox[{"(*", " ", 
       RowBox[{
        RowBox[{"Print", "[", 
         RowBox[{
         "\"\<Decoded Answer = \>\"", ",", "TheAnswer", ",", "\"\<\\n\>\"", 
          ",", "\"\<Real answer    = \>\"", ",", "RandomString"}], "]"}], 
        ";"}], " ", "*)"}], "\n", 
      RowBox[{
       RowBox[{"If", "[", 
        RowBox[{
         RowBox[{"TheAnswer", "\[Equal]", "RandomString"}], ",", 
         "\[IndentingNewLine]", 
         RowBox[{
          RowBox[{"Print", "[", 
           RowBox[{
           "TheAnswer", ",", " ", "\"\< Decoded Correctly! \>\"", ",", 
            "Correct", " ", ",", " ", "\"\< / \>\"", ",", " ", "Counter"}], 
           " ", "]"}], ";", " ", 
          RowBox[{"Correct", "++"}], ";"}], ",", 
         RowBox[{
          RowBox[{"Print", "[", 
           RowBox[{"\"\<Couldn't Decode \>\"", ",", "TheAnswer"}], "]"}], 
          ";"}]}], "\[IndentingNewLine]", "]"}], "\[IndentingNewLine]", 
       RowBox[{"Counter", "++"}]}], ";"}]}], "\[IndentingNewLine]", " ", 
    "]"}], "\[IndentingNewLine]", 
   RowBox[{"Print", "[", 
    RowBox[{
    "\"\<We got \>\"", ",", " ", "Correct", ",", " ", "\"\< out of \>\"", ",",
      " ", "NumberOfTimes"}], "]"}], "\[IndentingNewLine]"}]}]], "Input",
 CellChangeTimes->{{3.450092220032713*^9, 3.4500922455491495`*^9}, {
   3.4500924650325623`*^9, 3.450092520942399*^9}, {3.450092571404457*^9, 
   3.450092575640506*^9}, {3.450092762317072*^9, 3.450092827430051*^9}, {
   3.4500928965988207`*^9, 3.450092940361312*^9}, {3.45009297715385*^9, 
   3.450092982851987*^9}, {3.450093022809044*^9, 3.4500930847575035`*^9}, {
   3.4500931511923695`*^9, 3.450093174816104*^9}, {3.4500932127703004`*^9, 
   3.450093222964858*^9}, {3.4500933602308683`*^9, 3.4500933619533277`*^9}, {
   3.4500933969933634`*^9, 3.450093399316681*^9}, {3.4500934308517113`*^9, 
   3.450093463808773*^9}, {3.45009352880158*^9, 3.450093568658494*^9}, {
   3.4500936343022304`*^9, 3.450093662502499*^9}, {3.4500938084609213`*^9, 
   3.4500939053893313`*^9}, {3.450093966025918*^9, 3.4500940039500723`*^9}, 
   3.4500940364564896`*^9, {3.4500940808098245`*^9, 3.450094118603793*^9}, {
   3.4500942766194324`*^9, 3.4500942775407476`*^9}, {3.4500943652760305`*^9, 
   3.4500943660070744`*^9}, {3.450094642952541*^9, 3.450094643293027*^9}, {
   3.4500947254603586`*^9, 3.45009473172931*^9}},
 FontSize->18]
},
WindowSize->{952, 668},
WindowMargins->{{Automatic, 0}, {Automatic, 0}},
DockedCells->FEPrivate`If[
  FEPrivate`SameQ[FEPrivate`$ProductIDName, "MathematicaPlayer"], 
  FEPrivate`Join[{
    Cell[
     BoxData[
      GraphicsBox[
       RasterBox[CompressedData["
1:eJztXXdYFNfaz3O/f+79vudek3vTLKBIEaQpTRC7BgtqLCTWGxNjYsFookE0
NoxRY6oFuyIiWJCO9N4WWHrZpSy7VKkiBo2iy+5+Z/fsHg4zO7NLUZJ4fs/I
Mztz5j3v+87u+zvnPe+Meuu3L1v/P6+99poJ+Gf+t9dek+8LBwiBIHvu/Byd
ManLXMoSE+ExkQoZX+8W641rHWPUaDZZav+BZOoa6ZRVkhkftXrdrC3lg60h
JuGh667nVjNkJjbd4ywfjhzbcP7iQFUiICAgIHiVkHfVO0dHL0tnDFd/XNGH
q/g3bgrz84VFRVmnznAMrGRjDCSjxz6xmCFx3iFZtl/ickC6ZK/U6YtnS7Y/
c/6s23Zpt8V73aaOz8wdn+pbto4yqI2NG2qDCAgICAj+HIBTHn5GRrGhMV9H
r0hXr1hnbKGuQaGlQ6G9U5TJTJ7ZFJneaNnoMd0GZl1rjos3X+7efEn8uafk
k1OSlUfFi78RO30htl/5fOK8p2ZTmnXHNxlbVWVzh9osAgICAoI/ByANVVVU
5DpMKRs1pnS0fumYcTwDywIjh6IJixMcVrWNt5HTkL5Bt/7YR9OXi9yv1+7y
urfLu/1rryfbLnR/7iledUQ8b7vYcUXn+Ol1uhZ1EycLCwuH2iwCAgICgj8B
0AIQ2C9Yv0E4ckyNvmmh8YSs2U6chUvTlq9JcFnDc5pR9t4M/rw5/IULeDMd
M9Z9lrTVLWXLDs7Wr3O3uhVt3sn79Ev+2k2lLmvy5r+fY2JXZjO9qrh4qC0j
ICAgIPijQ4RB/vGAR72OUaHlpIqzhxsCL9QHXq4N9q4L8mryP9d051xT4IWm
oEtNARca75yvC79eG+Fbd9e3/q5vQ4TvvfDrjaE+94KuNgRfFvmdips8jZ+W
wd51VXl5bkCgIENDMwICAgKCvyoA9VSroOShbw7UjbXJ/+KzxqCrLSHhTZFJ
dbEZnRFRv4eGPQqP7IyK64yN74yL7wwP74iOackrbCkobs0taOXmt3FyHyRx
QPv6oIi68IhSz3NRK9bnht2tEgjwHiv4/JykpOgTJyI/3cBdubru7Pnq0tIh
sp7g1YUgNFTg4zPUWhAQvLpA0x9IQDUKyJlIKCxfuqbOYm7RQbfG8KC2pLzG
tIKWhHTeuXPtsUlPsoseZxU+zsp/xC14lMF9lJjSmc7pKK1oLxO2lQjasoub
knKqYzKqIlOrEzOrwuJDxtpfe2fMRSs7/wWLvZe5/DR/wS7HyTuNx/365lvh
7wxvWLuuLi1tqD1B8CoCcBDvtdfAxtfRAfsvqJcMMs0n+OsiIiLC1dX12LFj
PB6vfxJwGgIEVKuAqKKi6OB3FaZzBDPW5Xnsro2+W59e0JKc2ZGUGjppcqrD
NN4V7/a84of5JR25RR25hR0cLjjVEZ/Qnpp2PzWtOT6pNjqxKiy2PCymMjaJ
Fxrx7bsjdg1745dhbx/4xz+//Pv/nvjXsKi33m4Zrts9fkLzZa/B9QkBQZ9Q
sXFj+cqVciYaNqwqOXnQ5efl5Z09e3bQxRIQ/EEARlmBgYF79uzx8tI2mPMz
OKnXrqVcv56flFReVARmPVUCQSWPV87llsbF8QKDC095Zi9akW04JcveJXOB
a46He/XdoObY5N/iku9ncFPmL7ynY1ww0iB5xWp+cFhTblFrTmEzh9uSmtma
kNwaGdUYGlIXHCgM8C+/daPI93pxSFDW7ZtfvPPumRHjfN/R8X9nROUYPamh
kUxPr9vSuj787gv1DwGBlgBkBJiozNFx0CUTGiJ4FeDn5weYSMvGIj6//nYQ
d8VHZ/QND41491drK087uyAb23Rru6yJtlwbB96kqeWWtgJzxxqrWS02Mwr3
bK2/49MWGduWlH4vIztunnOVgUW1qW2Fnmmq/vikbV/yI2JqOTm1yZy6+OS6
qJi64BBRQED5rZulfr55167mBfjzbt3Ot5xeZ+oonjhdamYvNZkg0x/XbTmh
PibmhbpF4OMzWDn/qvx8ubQXlrQhGHKAeRDMzg36OhGhIYJXAWBO5Orq2tf8
c11ymuiLr/JMLTMMxsUYjeNaTOh0mCab5CiznCgzMpTpj5YZjJWNG5/n7iq6
ff1eVEJdQpowNSNyrnOpkWWpmS3PzK7c1DZ/jEnkRLuUI9/zoxOq4lMFEdGV
AcEVN2+X+PkW+Hhnel3m3bnTGp0iXXdIsnibZOpKqe08qYmtxNT6XkiI9qoC
FoAhAmxgHx3nDxumNnTAkS3awEd0Cgx38UEv5SOA8pJdu9CRyiNHUEegJTiF
LoH7PNXbk4AaFH3o0nCxcjlmZnjX8ryQykCYKULKI6PAcRAzgQJgQ8wIdvg6
OmiNA16LhKMYW3n6NHIpaAPtApeUL1gAdYZaIT/TL4S9QK1AG+hAIAfYCCRA
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
jHv1XEF4pCghpTktozklpSk2tvJueEFQUHN6dktmXms6tz2n6GFWwf3/7nm8
dPvTmRu6HVaJrRdLzGdLLabLLGdKJ0xt3/xlDSeTST16YS0Kvzw886MqpcOv
VfsyH41JOYqEHk1UKzKMqioa4OvjkMKY2kOggjeKRUIsXNMnAjDA4sJ71b9t
3Ag1wSuK4doNntPDzdRsF94Xg11QDt4F/sgqTJohTdRm4egaMjXGQbmJFOqh
DwbotxId6aU83ck0R+GiKF8ABI00BDkIpwD2qNvXZkzBrX8YXN0Gt9NB7/fF
yVSLftNQv6GxYJsFg+sWxEQPP/28e7zVM3OHbus5YkeXZ4u2ta7en394T1PY
rYfR0Q/iE9tSUv3nOCVbTCj5fFXOmR/ygoOFsQn1iUnC2PjqmNjGmJjau3cr
Q0Jy7vjfi0u6l8Spi0tv4uS1cwoebvjuscuurtmfPrVdKLZ4T2LuJB0/VWZs
JzOeJH9SyXJK20cbqgODhBUVFN3QyBYdQUkh/CDLEjYFfaKhl4CelwaoFiPQ
KWQ7ngViB+XRKnqt9csHvZxMbcwfCChrVWi9RllF0PsZ25cPjTQERpj4VEio
9Q+c5YU5lC4IDQ0EWvp54Hj5NKTx8VUWvAhXV2zcLB5rLDaxemxo0TbOttl8
Vp3DysIFm7MPudcGXGsJCWoJC2uMiAxZOC/tm23ZftfKgsOEkVGCiKiy8IjS
sPDCkJDioKDSO3cKb91Mu36tKiRSEJtWGZVSk5zdmpLzdN13Txdu67JZJjZ9
76nt3IdrtzzYe7j1hGfLxSvNV661el7o2Pvtgx27m05Rf614il6lpzLm4JVa
9GZMUEtDlFK0lww8TUQZbOOntKESuEZPf6eExveevVAAAoLrWRSt2NOVfZJP
yf7hXw+1dX0vExppyJX2Ji7tf+DalCQNIQ3Ra9sG0qk20l7QzAX3M1q+H3S8
fBoSanqZj8YLB64AhIjHa3XdLh6l1zVKr11Hv1HXQDTWtGb8ZJ7V/Jx5GzkH
vxb4Xay+4Su6dav61i3Ozz8WXvctvu1f4u8vCAgUBAYW37qVfv168rVrYMu4
ejXzypXYC+dLfG/zwxL4QbG1iZltabnPluwQO6zsdNnUeupiTXYOoyqCKsoB
EGHQ0rayiSLPQzkIV8O1CWsUGkIpIxCmhmrADF/dqXyjWu8JgnyJSnWqf+/3
1vK9Zy8ZUKvBcjhcBcM3+GgtPEt5WevLh0YaokyFhIM9/B4SGqK/jLR/L71k
ksbk0peQQBsSGqK/mkDtwf6B5dWmLBhEVzf53nruOKtzlF7NOLOaibaVVrZC
m0k8Q9N8HeNsI/u0mavjN3/Gu+lVfsOv3P92xR1/fsCdquBgUWxcbSa3Pr+o
LqegIT2zNia+MiiIc8Mv9qpXrNeVqCuXMq/5VIbHC6OSH1TV1kXEPp+8+vfl
m0T8skHReSCAMR9P36F6hiEcML840O39IwAuu7yc/zgDkdRQ/T8dQ/4fPQxi
vBK+xAxV//AHV48dg3unXjQGxdWi4mKB5/nwj9cH7tmTHxhUmZMjKCkRlpYK
i4srk5MLz5xNfn9VmPX84ElTOD//IORmN1VWtolEbXX1bU3N91va2lsVW3PL
g8bmjsam+w2NrbUNzVXCmoqKSj6/qozfJqp+9OBhe01N8axlT0xmNt64Myi2
ExD8uTDkNERA8IdFVWlpEZdLP44qFspzc8Ns5/jpG9wwNoqYM6dw3cYS96NZ
e49x9hzJ3Hck99BxsHEPHM13P8jf8U32VveUDV8lfOYWu37nTecl+6c6Rs9b
kL9kdan17DaL6Y8MrOvDyH+0SvAqAtYGD7UWBAR/MiAmCpjl9Mub/z45YozA
dq5k44nn+7ybvrsuOOIjOHpN+IOv6Mfrwh98ag9d/H37MeHGw/lr92Ws+zZ9
1cGi5bt8jO02vvF6pZFZnfGEJkPz+7oGNX43h9osAgICAoI/E8rS0o6OHO7x
+ptn39HvmuwiWbZXsun0E7eLD/Z6tRz0bvDwrj10tcbjSsO+i+0bj7as+7Z6
xYHyNYf5y3bxnT6vmvxhpJ55/CjdyrGGVXpG9Tp6Fd8dHWqDCAgICAj+PBAI
kn788cib7+7/v9dTdMdJHN6XzNkgWbZb8slPkq1nn3198fHuK527L993v/Rg
57nfPj32ePV3vy37pn353ntzNtZMcqk0nV5mZJU1Wi911Oji0XplI3XLFi0V
VlEL4QgICAgICNSiSiDITUw8NFLH45+vPzOxlk6cKZm0WDJtjWzWZtnifdI1
30s2/Nq98WT3phPP133/fOWhrkV7njq5ds5c/8hycfPUJTV2s/ijDXOGj4ob
PjJ+pA5nhG6OoXGFuqUoAgICAgICtcgIDV3/93+kDB8pNZkgHW8nM50msXPu
ctny++aDzz50k87cIlm0W7LIXeK8s9tp29MpH/9us/ypyezWo7+IioqFYAsK
Llm5OmXM2MC33ol8e0TcuyNzvTW/QY6AgICAgADiyv59B//1L5m+vsxgnNTM
utP1q7pU5ZPLovKKhx4nZXYrpFP+K53yUbfd8qcWzl2G03775AuKEF5sbMJS
lytv/Mf/P29HOi8ieTkCAgICAm1QJRBstbYSDB8p09Pres+pITqG3qbzKw+Z
zWLpxLkSG+cnxtO6jB3r45PUSuNcunRGR/fCsDdq1ckhICAgICCgICs5+ei/
/y3T0ev48isRwzvuqotKxLOWyl+UbT7tmZH9o8WrhAIBk8Di5OTjxkZx06eT
CREBAQEBgUb8vGVz24jRTZ7n2Js13wyQjbeXmTmKDa3aftXw/kwel/uzpYXo
0uXBU5OAgICA4C+IHA7n0tvD205d0Kbx74s/lBlNkBpb18TFa2zMz8uLcd1a
nZM7YB0JCAgICP6yuPT1zta9h7Vs3HLJS2Zs02ntWFFYqE378sLCCkJDBAQE
BAQMyMrI4B//Rfv2osrKbodZ9xcseXEqERAQEBC8OqgoLu5rFcGTlRu4HwzZ
/25JQEBAQPBHw/8DCp03+A==
        "], {{0, 0}, {557, 41}}, {0, 255}, ColorFunction -> RGBColor], 
       ImageSize -> {557, 41}, PlotRange -> {{0, 557}, {0, 41}}]], 
     "DockedCell", Background -> GrayLevel[0.866682], 
     CellFrame -> {{0, 0}, {0, 4}}, CellFrameColor -> 
     RGBColor[0.690074, 0.12871, 0.194598], CellMargins -> {{0, 0}, {-3, 0}}, 
     CellFrameMargins -> 0, ContextMenu -> None, 
     ComponentwiseContextMenu -> {}], 
    Cell[
     BoxData[
      GridBox[{{
         GraphicsBox[
          RasterBox[CompressedData["
1:eJztWl1Ik1EYFrqNEoLMbHPmNkRrEhJERj93ra4cJvbDRIsyMk1pc03tTL1w
aD+LfkQIJBkR/dBFdtHFDLywCykqoqgLIYRu6jbb8me933e+HT/P2fZN+sZ0
vg9n43zfec973nPe57zvOWNFDS2OhnU5OTlG+LyBj1S/ikAgEAgEAoFAIBAI
xEpFMBh8jUgPYG0z7d7MAOYedm/Bko4Ca5tp92YGSCokle5AUiGpdAeSCkml
O0RS/R1tjEajUIHvyIhdehPyLNZjrVSAgT5CK1Tmf32e+/qcdYEy+/4+vKTd
oQJN89PjojbaHcrCzE8qn0RGfIxrEjcF0SomD49hYqDDUUSGKtUKWRMYz42L
pFJDg1RPamGdlRWGuuDi2Yl+WHkoiy72W6jjgFeSm/wWKEAScCvtCxWpSzxt
1FPU9dJ76Lt8UnEmcVMQrWImUQE6nKJB7sgUKpb4LcpEtHiFpEpEKim2TI8n
IhXv4pAHXCAJEAPIq7d5JFAOYYEGKHEstTbQAJKSx+XH5ZKKE+CmIFq1ZC/E
SBVXoboJyMliKZKKgyapwLlK1ohHKgpYYfGRbnNpg4c8dP3prtckFQ0gUm5K
miKpVZxnRZP4KcSziiU1bjhOobpJ2TtIqnhITipYZ7byydJfoDzMpT9ZWMo1
EHbgBBLyhOWzlmakUtKQnB/VuUYkFbWNjZXIJHEKnFVL0t+IXSQVU4iRKkUk
JxVzhJI7hirpDpXOGzJ5eFLFvMNORxAlaJZhmtmZStQGAvSQA/FECSksH/kt
VLMyokw5qHDOFU3ipiBaxZmtTSo8U2lBI1LF/BWNXZ0Y1LckLo9IqQdYIWdA
9T0uvPT2J2qjrUr2lGMRSzrq4eiIVIxFGC5bMZO4KYhWcWYnSn8gv3j7k+vJ
GbVaSNXt9fo6O/XVib9Tpa+sClLdvtB0q+WSvjqRVGucVA/q6p9V1+irE0m1
xkk1cuLk2O49+upEUq1xUg1X14yZraSrS0ed+H+q9GFV/J+qx25/u9U40Nqa
aUMQ2YMrFRWf8g0vDh9JvUvgYjPR+8KIyA5AyiNeb1Pe5ql840xxSV97eyq9
Hp1y3nE602waYoXC19GRqInIGHC57lY53Lm53/O2RQ3Fr6qqNXUG609/LLX1
ulOiHyL74D/XeLPxvPiexHDtsuulyexbv2GqwLRgNP8xl/W7XAQE1IUQ1nHw
zNl5o2XYoc09RLbC5/E8te26V9+gfskY5SPkuss1abLc2Ljpm9E8Z7FFt++c
POroJoQWn1wotQAPj9XMFZp/m6y9bndGpoNYCZBikbNuoqBwsPY4IxIrQJu+
trYf5pLRfOOXotJw6d7Zsv0LtkOPzzb1ENKjolagueVD5YGodUfEZH2372Cm
p4X4X/wDFcRtOg==
           "], {{0, 0}, {199, 30}}, {0, 255}, ColorFunction -> RGBColor], 
          ImageSize -> {199, 30}, PlotRange -> {{0, 199}, {0, 30}}], 
         ButtonBox[
          GraphicsBox[
           RasterBox[CompressedData["
1:eJztlDFuhFAMRJHS5w45Re6RI+wFcoOUtNtR0lJSUlNSUtNS0m9JXjTKaPQh
UfpgCeT1n2+Px15ebu9vt6eqqp55Xnm+/I/L/p+1bbtt277vvJumIcKbnwWs
73vBsHVdE1bXNQ55Ho8HMOEd3L9tWRZ+6tRBrrjEMAwigHO/37M6SII40zRB
Q7QLkpQWjKOu63RqGHHVIoOYYAR16oucinYGxUo2jqMIzPNMnpQRPF2nMkeS
cCBDXsm7ZNZp6oZRS3wsIBFNIYM2iY8gYmJA8imqawHcOAKqio4KSp4O7Qjp
K1nOUygasaG2hoKSaud3krkArggZzyhhTohP3Uz7E0mNu9g98oj26exOSTon
fRUtn8IUJL+W80gyuz6OW3mgrSXXEv5dSaRTaRz9KQpY/knxtVomKdFQxvFT
JZFR6pFBJWT5tbEvR9+H3F6S+GOSMC+DTHtrHYyh32Qu855cdhn2CUundjY=

            "], {{0, 0}, {55, 14}}, {0, 255}, ColorFunction -> RGBColor], 
           ImageSize -> {55, 14}, PlotRange -> {{0, 55}, {0, 14}}], 
          ButtonData -> {
            URL["http://store.wolfram.com/view/app/playerpro/"], None}, 
          ButtonNote -> "http://store.wolfram.com/view/app/playerpro/"], 
         GraphicsBox[
          
          RasterBox[{{{132, 132, 132}, {156, 155, 155}}, {{138, 137, 137}, {
           171, 169, 169}}, {{138, 137, 137}, {171, 169, 169}}, {{138, 137, 
           137}, {171, 169, 169}}, {{138, 137, 137}, {171, 169, 169}}, {{138, 
           137, 137}, {171, 169, 169}}, {{138, 137, 137}, {171, 169, 169}}, {{
           138, 137, 137}, {171, 169, 169}}, {{138, 137, 137}, {171, 169, 
           169}}, {{138, 137, 137}, {171, 169, 169}}, {{138, 137, 137}, {171, 
           169, 169}}, {{138, 137, 137}, {171, 169, 169}}, {{138, 137, 137}, {
           171, 169, 169}}, {{135, 135, 135}, {167, 166, 166}}}, {{0, 0}, {2, 
           14}}, {0, 255}, ColorFunction -> RGBColor], ImageSize -> {2, 14}, 
          PlotRange -> {{0, 2}, {0, 14}}], 
         ButtonBox[
          GraphicsBox[
           RasterBox[CompressedData["
1:eJztlSGSg2AMhTuzfu+wB1qzR+gF9gbIWhwSW4lEV1ZWYyvxSPZb3vAmDdDq
zpCZdvKH5CUvfwhfx9+f48fhcPjk983vXy922eU9paqqcRx9HGcZhiE+PZ1O
KHVd24KOgt0WFKLQ27ZdJrper0JGcS5CVqs6n89yRpGl73tZBK6kkvv97kCe
ChOlLEvbVW2kiYPoxKcYRdwWld00jS2EcFSFMYXCqbOcBJzL5aJcxK7SFEFB
GQFn8AWupPUkMRfIJEK53W5d1z2hGVP7yohVbfanWoxAJQTfeywbT1+xK9mi
GQGTj8FT0uRAN3Tdjl3SlNANP5WoabIIRP+x52ojLEgXs8fxs7+R1cCXNFH6
SVJhKZwx0+BxBZ7nraGNpBSrEFlA1khgRDcCRg1navIWTeVKPVmliaeaL+c4
tCmcknRHfjtWaS6HNtYmC1wYjGJ+6eKjJcficWgVssz1nGbabFtD682gZaIO
MHXqkq/vyW3GFaQXliNuOhbz9lOHU3a6SrhWkCmnXC9pUoPBt1aQpquYrtJt
0f6Pazkd497W1MkSlxierkrrN254iz8oHqS0ByzxGzfOHx2yq9plYSl8l13e
Xf4ArlmHrg==
            "], {{0, 0}, {77, 14}}, {0, 255}, ColorFunction -> RGBColor], 
           ImageSize -> {77, 14}, PlotRange -> {{0, 77}, {0, 14}}], 
          ButtonData -> {
            URL[
            "http://www.wolfram.com/solutions/interactivedeployment/\
licensingterms.html"], None}, ButtonNote -> 
          "http://www.wolfram.com/solutions/interactivedeployment/\
licensingterms.html"]}}, ColumnsEqual -> False, 
       GridBoxAlignment -> {"Columns" -> {{Center}}, "Rows" -> {{Center}}}]], 
     "DockedCell", Background -> GrayLevel[0.494118], 
     CellFrame -> {{0, 0}, {4, 0}}, CellFrameColor -> 
     RGBColor[0.690074, 0.12871, 0.194598], CellMargins -> 0, 
     CellFrameMargins -> {{0, 0}, {0, -1}}, ContextMenu -> None, 
     ComponentwiseContextMenu -> {}, 
     ButtonBoxOptions -> {ButtonFunction :> (FrontEndExecute[{
          NotebookLocate[#2]}]& ), Appearance -> None, ButtonFrame -> None, 
       Evaluator -> None, Method -> "Queued"}]}, 
   FEPrivate`If[
    FEPrivate`SameQ[
     FrontEnd`CurrentValue[
      FrontEnd`EvaluationNotebook[], ScreenStyleEnvironment], "SlideShow"], {
    Inherited}, {}]], Inherited],
FrontEndVersion->"7.0 for Microsoft Windows (32-bit) (November 10, 2008)",
StyleDefinitions->FrontEnd`FileName[{"Creative"}, "NaturalColor.nb", 
  CharacterEncoding -> "WindowsANSI"]
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[545, 20, 17159, 435, 2477, "Input"],
Cell[17707, 457, 453, 11, 155, "Input"],
Cell[18163, 470, 4695, 130, 749, "Input"],
Cell[22861, 602, 1744, 45, 236, "Input"],
Cell[24608, 649, 2063, 57, 317, "Input"],
Cell[26674, 708, 8473, 201, 1100, "Input"]
}
]
*)

(* End of internal cache information *)
(* NotebookSignature vxpsXl1bVpMZFAwEsUX393AS *)
