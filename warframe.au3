#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.14.5
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

AutoItSetOption("MouseCoordMode", 2)
AutoItSetOption("PixelCoordMode", 2)

#include <Misc.au3>
#include <Array.au3>

HotKeySet("{F2}", "GetMouse")
HotKeySet("{F5}", "Quit")
HotKeySet("{F3}", "SolveCorpusPuzzle")
$handle = WinActivate("Warframe")
$dll = DllOpen("user32.dll")

While True
	Macro()
WEnd

Func Macro()
	If WinActive($handle) Then
		If _IsPressed(05, $dll) Then
			MouseDown("left")
			While _IsPressed(05, $dll)
				Sleep(1)
			WEnd
			While Not _IsPressed(05, $dll)
				Sleep(1)
			WEnd
			MouseUp("left")
;~ 			While Not _IsPressed(05, $dll)
;~ 				Send("{w down}")
;~ 				Send("{c down}")
;~ 				Send("{e}")
;~ 				Send("{w up}")
;~ 				Send("{c up}")
;~ 			WEnd
			While _IsPressed(05, $dll)
				Sleep(1)
			WEnd
		ElseIf _IsPressed(06, $dll) Then
			Send("{c down}")
			Send("{SPACE}")
			Send("{c up}")
			Sleep(275)
			Send("{LSHIFT}")
		EndIf
	EndIf
EndFunc   ;==>Macro

Func SolveCorpusPuzzle()
	Local $allSectorNodes[6][6], $successNodePositions = [3, 4, 5, 0, 1, 2]
	$data = FileReadToArray("test.txt")
	For $i = 0 To 5 ;each sector
		For $j = 0 To 5 ;each node
			$coords = StringSplit($data[($i * 6) + $j], ' ')
			If PixelGetColor($coords[1], $coords[2], $handle) > 15000000 Then
				$allSectorNodes[$i][$j] = True
			EndIf
		Next
	Next
	For $i = 0 To 5
		;calc amount of nodes for this sector
		Local $thisSectorNodes = [], $sectorCoords = StringSplit($data[$i * 6], ' ')
		_ArrayPop($thisSectorNodes)
		For $j = 0 To 5
			If $allSectorNodes[$i][$j] = True Then
				if $j = 0 and $allSectorNodes[$i][5] = True Then
					if $allSectorNodes[$i][4] = True Then
						_ArrayAdd($thisSectorNodes, 4)
						_ArrayAdd($thisSectorNodes, 5)
						_ArrayAdd($thisSectorNodes, 0)
					Else
						_ArrayAdd($thisSectorNodes, 5)
						_ArrayAdd($thisSectorNodes, 0)
						_ArrayAdd($thisSectorNodes, 1)
					EndIf
					$j = 6
				Else
					_ArrayAdd($thisSectorNodes, $j)
				EndIf
			EndIf
		Next
;~ 		_ArrayDisplay($thisSectorNodes)
		If UBound($thisSectorNodes) == 3 Then
			Local $diff = $successNodePositions[$i] - $thisSectorNodes[1], $mouseButtonToClick
			If Abs($diff) > 3 Then
				if $diff < 0 Then
					$diff = 6 - Abs($diff)
				ElseIf $diff > 0 Then
					$diff = - (6 - Abs($diff))
				EndIf
			EndIf
			if $diff < 0 Then
				$mouseButtonToClick = "right"
			else
				$mouseButtonToClick = "left"
			EndIf
			For $k = 0 To Abs($diff) - 1
				MouseClick($mouseButtonToClick, $sectorCoords[1], $sectorCoords[2])
				Sleep(500)
			Next
		EndIf
	Next
EndFunc   ;==>SolveCorpusPuzzle

Func Quit()
	Exit
EndFunc   ;==>Quit

Func GetMouse()
	$temp = MouseGetPos()
	MsgBox(0, "", $temp[0] & " " & $temp[1] & " " & PixelGetColor($temp[0], $temp[1]))
EndFunc   ;==>GetMouse
