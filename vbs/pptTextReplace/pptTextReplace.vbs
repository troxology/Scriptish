' File: pptTextReplace.vbs
' 
' Description: Finds all Powerpoint files in a given directory and replaces 
' bad text with good text.
' 
' Author: Tim Troxler
'
' Instructions:
'   - Backup original powerpoint files
'   - Change hardcoded start folder and bad/good text in the variables below
'   - Run from the windows command prompt as "cscript pptTextReplace.vbs"
'   - Done!
'
' Changelog:
' v1 - 4/11/14 - First commit to github. Quick and dirty version that runs 
' from command line. Any errors result in a skipped file. No preprocessing 
' error checking or logging  yet.  PPT directory and text are hardcoded.

' Change these 3 things before running!
Const strpptFolder = "C:\path\to\your\directory"
Const strFindText = "badtext"
Const strReplaceWith = "goodtext"

' Don't touch anything else below this line :-)

' File system object
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Folder object for hardcoded location above
Set objFolder = objFSO.GetFolder(strpptFolder)

' For every file in the directory...
Set colFiles = objFolder.Files
For Each objFile in colFiles

    ' If file contains ".ppt"...
    If InStr(objFile, ".ppt") Then
        ' Echo file name to the user
        Wscript.Echo "Processing " + objFile.Name
        
        ' Start powerpoint
        Set pptApp = CreateObject("Powerpoint.Application")
        pptApp.Visible = True
        pptApp.WindowState = 2
        
        ' Attempt to open the current file
        Set ppt = pptApp.Presentations.Open(strpptFolder + "\" + objFile.Name)
        
        ' Call the subroutine for replacing the bad text
        findAndReplace(ppt)
        
        ' Save and close the current file
        ppt.Save
        ppt.Close
        
    End If  ' End if .ppt file
    
Next ' Next file in the directory

' Subroutine to find and replace the bad text. Current powerpoint file is 
' passed in. Currently, the bad and good text are hardcoded as globals.
Sub findAndReplace(ppt)

    ' For each slide in the ppt...
    For Each objSlide In ppt.Slides
    
        ' For each shape on the current slide...
        For Each objShape In objSlide.Shapes
        
            ' If there is a text frame on the current object...
            If objShape.HasTextFrame Then
            
                ' If current text frame has text...
                If objShape.TextFrame.HasText Then
                
                    ' Replace all occurrences of bad text with good text
                    Set objTextRange = objShape.TextFrame.TextRange
                    Set objTempText = objShape.TextFrame.TextRange.Find(strFindText, 0, False, True)
                    On Error Resume Next
                    Do While Not objTempText Is Nothing
                            objTempText.Select
                            objTempText.Text = strReplaceWith
                            Set objTempText = objTextRange.Find(strFindText, objTempText.Start + objTempText.Length, False, True)
                    Loop
                    On Error Goto 0
                    
                End If ' textframe has text
                
            End If ' shape has textframe
            
        Next ' shape
        
    Next ' slide
    
End Sub
