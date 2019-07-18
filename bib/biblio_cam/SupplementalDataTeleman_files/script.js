function dropdown(list)
{
	var item=list.options[list.selectedIndex].value;

	if (item != "nowhere") 
	{
		top.location=item;
	}
}
	
function openhelp()
{
	window.open('/popup/help', 'helpwindow', 'width=580,height=410,left=0,top=0,screenX=0,screenY=0,resizable=no,scrollbars=yes');
	self.name="main";
}

function opensearchhelp()
{
	window.open('/popup/help/Finding_Information.htm','helpwindow','width=580,height=410,left=0,top=0,screenX=0,screenY=0,resizable=no,scrollbars=yes');
	self.name="main";
}

function statecodeselect(thisform, thislist, list1, list2, countrycodefield, countrydescfield)
{
	var theform = eval("document." + thisform);
	var thelist = eval("theform." + thislist);
	eval("theform." + list1 + ".selectedIndex=0");
	eval("theform." + list2 + ".selectedIndex=0");
	eval("theform.elements[\"" + countrycodefield + "\"].value=thelist.options[thelist.selectedIndex].text");
	eval("theform.elements[\"" + countrydescfield + "\"].value=thelist.options[thelist.selectedIndex].text");
}

function clearstates ( thisform, strControlNameRoot, strIdentifiers  )
{
	eval ( "document." + thisform + "." + strControlNameRoot + ".value=''" );
	var colIdentifiers = strIdentifiers.split ( ";" );
	for ( var iCounter = 0; iCounter < colIdentifiers.length; iCounter++ )
		eval ( "document." + thisform + "." + strControlNameRoot + "_" + colIdentifiers[iCounter] + ".selectedIndex=0" );
}

function finalstate ( thisform, strControlNameRoot, strSelectRef, strIdentifiers )
{
	var strCountryID = eval ( "document." + thisform + "." + strSelectRef + ".options[document." + thisform + "." + strSelectRef + ".selectedIndex].value" );
	if ( strIdentifiers.indexOf ( strCountryID ) == -1 || strCountryID == "0")
		return;
	var strStateID = eval ( "document." + thisform + "." + strControlNameRoot + "_" + strCountryID + ".options[document." + thisform + "." + strControlNameRoot + "_" + strCountryID + ".selectedIndex].value" );
	eval ( "document." + thisform + "." + strControlNameRoot ).value = strStateID;
}

function setstate ( thisform, strControlNameRoot, strIdentifier, strSelectRef, strIdentifiers, evt )
{
	// The following line ensures that the event type can be picked up across all IE and NN
	var eventType = evt.type || arguments.callee.caller.name || window.event.type;
	if ( eventType.indexOf ( "on" ) != 0 )
		eventType = "on" + eventType;
	if ( strIdentifier != "" )
	{
		if ( eval ( "document." + thisform + "." + strSelectRef + ".options[document." + thisform + "." + strSelectRef + ".selectedIndex].value" ) != strIdentifier )
		{
			// This part will be hit if the user selects a drop down that isn't the one that they should
			// The country has not been set, or is set to something other than the state box that was selected
			// Need to do two things. Set the country to the relevant value and clear the other boxes
			if ( eventType == "onchange" )
			{
				// First, clear the other drop downs' values
				var colIdentifiers = strIdentifiers.split ( ";" );
				for ( var iCounter = 0; iCounter < colIdentifiers.length; iCounter++ )
				{
					if ( colIdentifiers[iCounter] != strIdentifier )
						eval ( "document." + thisform + "." + strControlNameRoot + "_" + colIdentifiers[iCounter] + ".selectedIndex=0" );
				}
				// Clear the text box
				eval ( "document." + thisform + "." + strControlNameRoot + ".value=''" );
				// Now set the country
				eval ( "document." + thisform + "." + strSelectRef + ".selectedIndex = " + searchArray ( eval ( "document." + thisform + "." + strSelectRef + ".options" ), strIdentifier ) );
			}
			return;
		}
		return;
	}
	else
	{
		if ( ( eval ( "document." + thisform + "." + strSelectRef + ".selectedIndex" ) == 0 )
			||
				( eval ( "document." + thisform + "." + strSelectRef + ".options[document." + thisform + "." + strSelectRef + ".selectedIndex].value" ) == 1224 )
			||
				( eval ( "document." + thisform + "." + strSelectRef + ".options[document." + thisform + "." + strSelectRef + ".selectedIndex].value" ) == 1037 ) )
		{
			// This part will be entered when the user selects the text box and that doesn't match what's in the country box
			// What needs to be done is the country box is aligned and the other state input boxes to be reset
			if ( eventType == "onchange" )
			{
				// First, clear the drop downs' values
				var colIdentifiers = strIdentifiers.split ( ";" );
				for ( var iCounter = 0; iCounter < colIdentifiers.length; iCounter++ )
					eval ( "document." + thisform + "." + strControlNameRoot + "_" + colIdentifiers[iCounter] + ".selectedIndex=0" );
				// Now set the country
				// Should we set it to a country? Or should it be blank? Think it should be set to blank.
				eval ( "document." + thisform + "." + strSelectRef + ".selectedIndex = 0" );
			}
			return;
		}
		return;
	}
}

// This function searches an array and returns the index at which the search string occurs
function searchArray ( arrToSearch, strSearchValue )
{
	for ( var iCounter = 0; iCounter < arrToSearch.length; iCounter++ )
		if ( arrToSearch[iCounter].value == strSearchValue )
			return iCounter;
	return -1;
}

function sethidden(value,field,value2)
{
	if(!value2)
	{
		if(field.options)
			value2=field.options[field.selectedIndex].value;
		else
			value2=field.value;
	}

	if(value2!="")
	{
		field.form.elements[value].value=value2;
	}
}

function setEcommerce2Hidden()
{
	sethidden('titleid',orderdetails.addresstitleid);
	sethidden('firstname',orderdetails.addressfirstname);
	sethidden('lastname',orderdetails.addresslastname);
	sethidden('address1',orderdetails.addressstreet);
	sethidden('address2',orderdetails.addressstreet2);
	sethidden('city',orderdetails.addresscity);
	sethidden('state',orderdetails.addressstate);
	sethidden('countryid',orderdetails.addresscountry);
	sethidden('zip',orderdetails.addresspostcode);
	sethidden('telephone',orderdetails.addressphone);
}

