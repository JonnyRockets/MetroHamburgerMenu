#########################################################################
# Author:  Kevin RAHETILAHY                                             #
# E-mail: kevin.rhtl@gmail.com                                          #
# Blog: dev4sys.blogspot.fr                                             #
#########################################################################


#########################################################################
#                        Add shared_assemblies                          #
#########################################################################


[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')      | out-null  
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') | out-null


#########################################################################
#                        Load Main Panel                                #
#########################################################################

$Global:pathPanel= split-path -parent $MyInvocation.MyCommand.Definition

function LoadXaml ($filename){
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}


$XamlMainWindow=LoadXaml($pathPanel+"\form.xaml")
$reader = (New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form = [Windows.Markup.XamlReader]::Load($reader)


#########################################################################
#                        HAMBURGER VIEWS                                #
#########################################################################

#******************* Target View  *****************

$HamburgerMenuControl = $Form.FindName("HamburgerMenuControl")

$HomeView      = $Form.FindName("HomeView") 
$SettingsView  = $Form.FindName("SettingsView")
$PrivateView   = $Form.FindName("PrivateView") 
$AboutView     = $Form.FindName("AboutView") 

#******************* Load Other Views  *****************
$viewFolder = $pathPanel +"\views"

$XamlChildWindow = LoadXaml($viewFolder+"\Home.xaml")
$Childreader     = (New-Object System.Xml.XmlNodeReader $XamlChildWindow)
$HomeXaml        = [Windows.Markup.XamlReader]::Load($Childreader)


$XamlChildWindow = LoadXaml($viewFolder+"\Private.xaml")
$Childreader     = (New-Object System.Xml.XmlNodeReader $XamlChildWindow)
$PrivateXaml     = [Windows.Markup.XamlReader]::Load($Childreader)


$XamlChildWindow = LoadXaml($viewFolder+"\Settings.xaml")
$Childreader     = (New-Object System.Xml.XmlNodeReader $XamlChildWindow)
$SettingsXaml    = [Windows.Markup.XamlReader]::Load($Childreader)

$XamlChildWindow = LoadXaml($viewFolder+"\About.xaml")
$Childreader     = (New-Object System.Xml.XmlNodeReader $XamlChildWindow)
$AboutXaml       = [Windows.Markup.XamlReader]::Load($Childreader)

    
$HomeView.Children.Add($HomeXaml)          | Out-Null
$SettingsView.Children.Add($SettingsXaml)  | Out-Null    
$PrivateView.Children.Add($PrivateXaml)    | Out-Null      
$AboutView.Children.Add($AboutXaml)        | Out-Null

#******************************************************
# Initialize with the first value of Item Section *****
#******************************************************

$HamburgerMenuControl.SelectedItem = $HamburgerMenuControl.ItemsSource[0]


#########################################################################
#                        HAMBURGER EVENTS                               #
#########################################################################

#******************* Items Section  *******************

$HamburgerMenuControl.add_ItemClick({
    
   $HamburgerMenuControl.Content = $HamburgerMenuControl.SelectedItem
   $HamburgerMenuControl.IsPaneOpen = $false

})

#******************* Options Section  *******************

$HamburgerMenuControl.add_OptionsItemClick({

    $HamburgerMenuControl.Content = $HamburgerMenuControl.SelectedOptionsItem
    $HamburgerMenuControl.IsPaneOpen = $false

})



#########################################################################
#                        Show Dialog                                    #
#########################################################################

$Form.add_MouseLeftButtonDown({
   $_.handled=$true
   $this.DragMove()
})
     


$Form.ShowDialog() | Out-Null
  
