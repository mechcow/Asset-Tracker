/**
 * Swap Select
 * 
 * Author: KMF Online
 * 
 * Version: 0.2
 * Date: 24.03.2009
 */
   

 /** 
 * function SwapSelect()
 *
 * Constructor. Create a new swap selection Object
 * 
 * @param   str_pSwapId     		String				The main id of the swap seletion element
 * @param   arr_pElements       Array 				Array of Array's with option tag value => text pairs
 * @param   size								int						Size of Select-Lists
 */
function SwapSelect(str_pSwapId, arr_pElements, size)
{
  // Set default values
  this.id = str_pSwapId;
  this.bol_debugToAlert = false;
  this.structure = arr_pElements;
	this.size = size ? size : 6;
  
  // Set default language values
  this.languagesValues = new Object();
  this.languagesValues["AviableHeadline"] = "Available";
  this.languagesValues["SelectedHeadline"] = "Selected";
  this.languagesValues["AssumeButtonTitleAttr"] = "add";
  this.languagesValues["AssumeButtonText"] = "add";
  this.languagesValues["AssumeAllButtonTitleAttr"] = "add all";
  this.languagesValues["AssumeAllButtonText"] = "add all";
  this.languagesValues["TakeBackButtonTitleAttr"] = "remove";
  this.languagesValues["TakeBackButtonText"] = "remove";
  this.languagesValues["TakeBackAllButtonTitleAttr"] = "remove all";
  this.languagesValues["TakeBackAllButtonText"] = "remove all";
  this.setLanguage = __swapSel_setLanguageValues;
  
  // Bind object functions
  this.debug = __swapSel_debug;
  this.getSelection = __swapSel_getCurrentSelection;
  this.changeState = __swapSel_changeState;
  this.rebuildSelects = __swapSel_rebuildSelectTags;
  this.rebuildHiddenFields = __swapSel_rebuildHiddenFields;
  this.buildStructure = __swapSel_buildStructure;
	
  // Build HTML Code
  this.buildHtml = __swapSel_buildCode;
  this.buildHtml();
	
	this.rebuildSelects();
	this.rebuildHiddenFields();
}


/** 
 * function __swapSel_setLanguageValues()
 *
 * Set the languange depending values
 *
 * Structor of values array:
 * [0] => Headline for the aviable select box
 * [1] => Headline for the selected select box
 * [2] => Assume button title attribute
 * [3] => Assume button text (text only fallback version)
 * [4] => Assume all button title attribute
 * [5] => Assume all button text (text only fallback version
 * [6] => Take back button title attribute
 * [7] => Take back button text (text only fallback version
 * [8] => Take back all button title attribute
 * [9] => Take back all button text (text only fallback version 
 */
function __swapSel_setLanguageValues(arr_pLangValues)
{
  this.languagesValues["AviableHeadline"] = arr_pLangValues[0];
  this.languagesValues["SelectedHeadline"] = arr_pLangValues[1];
  this.languagesValues["AssumeButtonTitleAttr"] = arr_pLangValues[2];
  this.languagesValues["AssumeButtonText"] = arr_pLangValues[3];
  this.languagesValues["AssumeAllButtonTitleAttr"] = arr_pLangValues[4];
  this.languagesValues["AssumeAllButtonText"] = arr_pLangValues[5];
  this.languagesValues["TakeBackButtonTitleAttr"] = arr_pLangValues[6];
  this.languagesValues["TakeBackButtonText"] = arr_pLangValues[7];
  this.languagesValues["TakeBackAllButtonTitleAttr"] = arr_pLangValues[8];
  this.languagesValues["TakeBackAllButtonText"] = arr_pLangValues[9];
}
 
/** 
 * function __swapSel_buildCode()
 *
 * Build the the HTML content
 */
function __swapSel_buildCode()
{
  // Create main div
  obj_swapSel = document.createElement('div');
  obj_attribute = document.createAttribute("class");
  obj_attribute.nodeValue = 'swap_select';
  obj_swapSel.setAttributeNode(obj_attribute);
  
  // Create hidden fields container div an append it into main div
  obj_hiddenContainer = document.createElement('div');
  obj_attribute = document.createAttribute("id");
  obj_attribute.nodeValue = this.id + '_selected_fields';
  obj_hiddenContainer.setAttributeNode(obj_attribute);
  obj_swapSel.appendChild(obj_hiddenContainer);
  
  // Create 'swap_select_all' div an append it into main div
  obj_all = document.createElement('div');
  obj_attribute = document.createAttribute("class");
  obj_attribute.nodeValue = 'swap_select_all';
  obj_all.setAttributeNode(obj_attribute);
  obj_swapSel.appendChild(obj_all);
  
  // Create 'swap_select_available' p tag an append it into 'swap_select_all'
  obj_p = document.createElement('p');
  obj_attribute = document.createAttribute("class");
  obj_attribute.nodeValue = 'swap_select_available';
  obj_p.setAttributeNode(obj_attribute);
  obj_all.appendChild(obj_p);
  
  // Create label an append it into p tag
  obj_label = document.createElement('label');
  obj_attribute = document.createAttribute("for");
  obj_attribute.nodeValue = this.id + '_all';
  obj_label.setAttributeNode(obj_attribute);
  obj_p.appendChild(obj_label);
  
  // Create text node and append into label
  obj_text = document.createTextNode(this.languagesValues["AviableHeadline"]);
  obj_label.appendChild(obj_text);
  
  // Create p tag an append it into 'swap_select_all'
  obj_p = document.createElement('p');
  obj_all.appendChild(obj_p);
  
  // Creaate select tag an append it into p tag
  obj_select = document.createElement('select');
  obj_attribute = document.createAttribute("id");
  obj_attribute.nodeValue = this.id + '_all';
  obj_select.setAttributeNode(obj_attribute);
  
  obj_attribute = document.createAttribute("name");
  obj_attribute.nodeValue = this.id + '_all';
  obj_select.setAttributeNode(obj_attribute);
  
  obj_attribute = document.createAttribute("size");
  obj_attribute.nodeValue = this.size;
  obj_select.setAttributeNode(obj_attribute);
  
  obj_attribute = document.createAttribute("multiple");
  obj_attribute.nodeValue = 'multiple';
  obj_select.setAttributeNode(obj_attribute);
  
  obj_p.appendChild(obj_select);
  
  // Add all option tags into select box
  for (i = 0; i < this.structure.length; i++)
  {
    // Create a option tag and append it into select box
    obj_optionTag = document.createElement('option');
    obj_attributeTag = document.createAttribute("value");
    obj_attributeTag.nodeValue = this.structure[i][0];
    obj_optionTag.setAttributeNode(obj_attributeTag);
    
    obj_text = document.createTextNode(this.structure[i][1]);
    obj_optionTag.appendChild(obj_text);
   
	 	obj_select.ondblclick = function(e) {swapSel_switchItems(obj_selfRef, true, false);}
		 
    obj_select.appendChild(obj_optionTag);
  }
  
  // Create 'swap_select_options' div an append it into main div
  obj_options = document.createElement('div');
  obj_attribute = document.createAttribute("class");
  obj_attribute.nodeValue = 'swap_select_options';
  obj_options.setAttributeNode(obj_attribute);
  obj_swapSel.appendChild(obj_options);
  
  // Create p tag an append it into 'swap_select_options'
  obj_p = document.createElement('p');
  obj_options.appendChild(obj_p);
  
  // Save reference to this as a global var
  var obj_selfRef = this;
  
  
  // Create 'swap_select_options_all_right' a tag
  obj_a = document.createElement('a');
  obj_attribute = document.createAttribute("a");
  obj_attribute.nodeValue = '#';
  obj_a.setAttributeNode(obj_attribute);
  
  obj_a.onclick = function(e) {swapSel_switchItems(obj_selfRef, true, true);}
  obj_a.onkeydown = function(e) {
    if ((e.keyCode == 0) || (e.keyCode == 13)) swapSel_switchItems(obj_selfRef, true, false);
  }
  
  obj_attribute = document.createAttribute("class");
  obj_attribute.nodeValue = 'swap_select_options_all_right';
  obj_a.setAttributeNode(obj_attribute);
  
  obj_attribute = document.createAttribute("title");
  obj_attribute.nodeValue = this.languagesValues["AssumeAllButtonTitleAttr"];
  obj_a.setAttributeNode(obj_attribute);
  
  obj_p.appendChild(obj_a);
  
  // Create span tag and append it into a tag and append it into p tag
  obj_span = document.createElement('span');
  obj_text = document.createTextNode(this.languagesValues["AssumeAllButtonText"]);
  obj_span.appendChild(obj_text);
  obj_a.appendChild(obj_span);
  
  // Create 'swap_select_options_right' a tag and append it into p tag
  obj_a = document.createElement('a');
  obj_attribute = document.createAttribute("a");
  obj_attribute.nodeValue = '#';
  obj_a.setAttributeNode(obj_attribute);
  
  obj_a.onclick = function(e) {swapSel_switchItems(obj_selfRef, true, false);}
  obj_a.onkeydown = function(e) {
    if ((e.keyCode == 0) || (e.keyCode == 13)) swapSel_switchItems(obj_selfRef, true, false);
  }
  
  obj_attribute = document.createAttribute("class");
  obj_attribute.nodeValue = 'swap_select_options_right';
  obj_a.setAttributeNode(obj_attribute);
  
  obj_attribute = document.createAttribute("title");
  obj_attribute.nodeValue = this.languagesValues["AssumeButtonTitleAttr"];
  obj_a.setAttributeNode(obj_attribute);
  
  obj_p.appendChild(obj_a);
  
  // Create span tag and append it into a tag and append it into p tag
  obj_span = document.createElement('span');
  obj_text = document.createTextNode(this.languagesValues["AssumeButtonText"]);
  obj_span.appendChild(obj_text);
  obj_a.appendChild(obj_span);

  // Create 'swap_select_options_left' a tag
  obj_a = document.createElement('a');
  obj_attribute = document.createAttribute("a");
  obj_attribute.nodeValue = '#';
  obj_a.setAttributeNode(obj_attribute);  
  
  obj_a.onclick = function(e) {swapSel_switchItems(obj_selfRef, false, false);}
  obj_a.onkeydown = function(e) {
    if ((e.keyCode == 0) || (e.keyCode == 13)) swapSel_switchItems(obj_selfRef, true, false);
  }
  
  obj_attribute = document.createAttribute("class");
  obj_attribute.nodeValue = 'swap_select_options_left';
  obj_a.setAttributeNode(obj_attribute);
  
  obj_attribute = document.createAttribute("title");
  obj_attribute.nodeValue = this.languagesValues["TakeBackButtonTitleAttr"];
  obj_a.setAttributeNode(obj_attribute);
  
  obj_p.appendChild(obj_a);
  
  // Create span tag and append it into a tag and append it into p tag
  obj_span = document.createElement('span');
  obj_text = document.createTextNode(this.languagesValues["TakeBackButtonText"]);
  obj_span.appendChild(obj_text);
  obj_a.appendChild(obj_span);
  
  // Create 'swap_select_options_alll_left' a tag
  obj_a = document.createElement('a');
  obj_attribute = document.createAttribute("a");
  obj_attribute.nodeValue = '#';
  obj_a.setAttributeNode(obj_attribute);
  
  obj_a.onclick = function(e) {swapSel_switchItems(obj_selfRef, false, true);}
  obj_a.onkeydown = function(e) {
    if ((e.keyCode == 0) || (e.keyCode == 13)) swapSel_switchItems(obj_selfRef, true, false);
  }
  
  obj_attribute = document.createAttribute("class");
  obj_attribute.nodeValue = 'swap_select_options_alll_left';
  obj_a.setAttributeNode(obj_attribute);
  
  obj_attribute = document.createAttribute("title");
  obj_attribute.nodeValue = this.languagesValues["TakeBackAllButtonTitleAttr"];
  obj_a.setAttributeNode(obj_attribute);
  
  obj_p.appendChild(obj_a);
  
  // Create span tag and append it into a tag
  obj_span = document.createElement('span');
  obj_text = document.createTextNode(this.languagesValues["TakeBackAllButtonText"]);
  obj_span.appendChild(obj_text);
  obj_a.appendChild(obj_span);
  
  // Create 'swap_select_select' div an append it into main div
  obj_select = document.createElement('div');
  obj_attribute = document.createAttribute("class");
  obj_attribute.nodeValue = 'swap_select_select';
  obj_select.setAttributeNode(obj_attribute);
  obj_swapSel.appendChild(obj_select);
  
  // Create 'swap_select_selected' p tag an append it into 'swap_select_select'
  obj_p = document.createElement('p');
  obj_attribute = document.createAttribute("class");
  obj_attribute.nodeValue = 'swap_select_selected';
  obj_p.setAttributeNode(obj_attribute);
  obj_select.appendChild(obj_p);
  
  // Create label an append it into p tag
  obj_label = document.createElement('label');
  obj_attribute = document.createAttribute("for");
  obj_attribute.nodeValue = this.id + '_selected';
  obj_label.setAttributeNode(obj_attribute);
  obj_p.appendChild(obj_label);
  
  // Create text node and append into label
  obj_text = document.createTextNode(this.languagesValues["SelectedHeadline"]);
  obj_label.appendChild(obj_text);
  
  // Create p tag an append it into 'swap_select_all'
  obj_p = document.createElement('p');
  obj_select.appendChild(obj_p);
  
  // Creaate select tag an append it into p tag
  obj_select = document.createElement('select');
  obj_attribute = document.createAttribute("id");
  obj_attribute.nodeValue = this.id + '_selected';
  obj_select.setAttributeNode(obj_attribute);
  
  obj_attribute = document.createAttribute("name");
  obj_attribute.nodeValue = this.id + '_selected';
  obj_select.setAttributeNode(obj_attribute);
  
  obj_attribute = document.createAttribute("size");
  obj_attribute.nodeValue = this.size;
  obj_select.setAttributeNode(obj_attribute);
  
  obj_attribute = document.createAttribute("multiple");
  obj_attribute.nodeValue = 'multiple';
  obj_select.setAttributeNode(obj_attribute);
  
	obj_select.ondblclick = function(e) {swapSel_switchItems(obj_selfRef, false, false);}
	
  obj_p.appendChild(obj_select);
  
  // Write tmp element to get parent
  document.write("<div id='" + this.id + "_tmp'></div>");
  obj_parentNode = document.getElementById(this.id + '_tmp').parentNode;
  
  // Add swap select element to parent element
  obj_parentNode.appendChild(obj_swapSel);
  
  // Delete tmp element
  for (i = 0; i < obj_parentNode.childNodes.length; i++)
  {
    if ((obj_parentNode.childNodes[i].nodeType == 1) && (obj_parentNode.childNodes[i].nodeName.toLowerCase() == 'div') && (obj_parentNode.childNodes[i].id == this.id + '_tmp'))
    {
      obj_parentNode.removeChild(obj_parentNode.childNodes[i]);
    }
  }
}
  
   
/**
 * function __swapSel_buildStructure()
 *
 * Build the data structure from the current values of the select box
 * 
 * Structure:
 * 	[0] => Array
 *   		    [0] => Option element value (String)
 *   				[1] => Option element text (String)
 *   				[2] => Option element selected? (Boolean)
 *   [1] => Array
 *   				...
 */
function __swapSel_buildStructure()
{
  // Get the select tag that's hold all entries
  obj_allTag = document.getElementById(this.id + '_all');

  // Enumerate over all options elemnts and build the array structure
  for (i = 0; i < obj_allTag.options.length; i++)
  {
    this.structure.push(new Array(obj_allTag.options[i].value, obj_allTag.options[i].text, false));
  }
}


/** function __swapSel_getCurrentSelection()
 *
 * Get all / selected items of a select tag
 * 
 * @param   obj_pSelectElement  Object				The HTML select object
 * @param		bol_pAll						Boolean				Get all elements or just the currently selected items
 * 
 * @return  arr_selectedItems		Array					List of the selected elements as indexes in the page selection list
 */ 
function __swapSel_getCurrentSelection(obj_pSelectElement, bol_pAll)
{
  arr_selectedItems = new Array();
  
  // Iterate over all options elements
  for (i = 0; i < obj_pSelectElement.options.length; i++)
  {
    // Get only wanted elements
    if (((bol_pAll == false) && (obj_pSelectElement.options[i].selected == true)) || (bol_pAll == true))
    {
      // Find position in original select list.
      for (x = 0; x < this.structure.length; x++)
      {
        if ((obj_pSelectElement.options[i].value == this.structure[x][0]) &&
            (obj_pSelectElement.options[i].text == this.structure[x][1]))
        {
          arr_selectedItems.push(x);
        }
      }
    }
  }
 
  return arr_selectedItems;
}


/**
 * function  __swapSel_changeState()
 *
 * Chage the state of options elements inside the array structure
 *
 * @param   arr_pEntries        Array         List of elements (indexes) that should be changed
 * @param   bol_pState          Boolean       The state to set to
 */
function __swapSel_changeState(arr_pEntries, bol_pState)
{
  for (i = 0; i < arr_pEntries.length; i++)
  {
    this.structure[arr_pEntries[i]][2] = bol_pState;
  }
}


/**
 * function  __swapSel_rebuildSelectTags()
 *
 * Rebuild both select boxes
 */
function __swapSel_rebuildSelectTags()
{
  // Get both select elements
  obj_allTag = document.getElementById(this.id + '_all');
  obj_selectedTag = document.getElementById(this.id + '_selected');

  // Delete all child notes in the "all selection" select box 
  for (i = obj_allTag.childNodes.length - 1; i >= 0; i--)
  {
    obj_allTag.removeChild(obj_allTag.childNodes[i]);
  }

  // Add only not selected elements to the "all selection" select box 
  for (i = 0; i < this.structure.length; i++)
  {
    if (this.structure[i][2] == false)
    {
      // Create a option tag
      obj_optionTag = document.createElement('option');

      // Create the 'value' attribute and set the content
      obj_attributeTag = document.createAttribute("value");
      obj_attributeTag.nodeValue = this.structure[i][0];

      // Append attribute to option tag 
      obj_optionTag.setAttributeNode(obj_attributeTag);

      // Create text node and append into option tag
      obj_text = document.createTextNode(this.structure[i][1]);
      obj_optionTag.appendChild(obj_text);

      // Append option tag into select box
      obj_allTag.appendChild(obj_optionTag);
    }
  }

  // Delete all child notes in the "selected selection" select box 
  for (i = obj_selectedTag.childNodes.length - 1; i >= 0; i--)
  {
    obj_selectedTag.removeChild(obj_selectedTag.childNodes[i]);
  }

  // Add only not selected elements to the "all selection" select box 
  for (i = 0; i < this.structure.length; i++)
  {
    if (this.structure[i][2] == true)
    {
      // Create a option tag
      obj_optionTag = document.createElement('option');

      // Create the 'value' attribute and set the content
      obj_attributeTag = document.createAttribute("value");
      obj_attributeTag.nodeValue = this.structure[i][0];

      // Append attribute to option tag 
      obj_optionTag.setAttributeNode(obj_attributeTag);

      // Create text node and append into option tag
      obj_text = document.createTextNode(this.structure[i][1]);
      obj_optionTag.appendChild(obj_text);

      // Append option tag into select box
      obj_selectedTag.appendChild(obj_optionTag);
    }
  }
}


/**
 * function  __swapSel_rebuildHiddenFields()
 *
 * Rebuild the hidden fields for transfering the selected entries
 */  
function __swapSel_rebuildHiddenFields()
{
  // Get hidden fields container
  obj_hiddenFiledsContainer = document.getElementById(this.id + '_selected_fields');
  
  // Check if the container is a div element
  if (obj_hiddenFiledsContainer && (obj_hiddenFiledsContainer.nodeType == 1) && (obj_hiddenFiledsContainer.nodeName.toLowerCase() == 'div'))
  {
    // Delete all child notes in the "all selection" select box 
    for (i = obj_hiddenFiledsContainer.childNodes.length - 1; i >= 0; i--)
    {
      obj_hiddenFiledsContainer.removeChild(obj_hiddenFiledsContainer.childNodes[i]);
    }
    
    // Add only not selected elements to the hidden field cointainer
    for (i = 0; i < this.structure.length; i++)
    {
      if (this.structure[i][2] == true)
      {
        // Create a input field
        obj_optionTag = document.createElement('input');
        
        // Create the 'type' attribute and append it to the input field  
        obj_attributeTag = document.createAttribute("type");
        obj_attributeTag.nodeValue = 'hidden';
        obj_optionTag.setAttributeNode(obj_attributeTag);
        
        // Create the 'name' attribute, set his content and append it to the input field  
        obj_attributeTag = document.createAttribute("name");
        obj_attributeTag.nodeValue = this.id;
        obj_optionTag.setAttributeNode(obj_attributeTag);
        
        // Create the 'value' attribute, set his content and append it to the input field  
        obj_attributeTag = document.createAttribute("value");
        obj_attributeTag.nodeValue = this.structure[i][0];
        obj_optionTag.setAttributeNode(obj_attributeTag);
        
        // Append hidden field into the cointainer
        obj_hiddenFiledsContainer.appendChild(obj_optionTag);
      }
    }
  }
  else
  {
    __swapSel_debug("Error: Swap Select can't find the requiered hidden field container for »" + this.id + "«!");
  }
}


/** 
 * function __swapSel_debug()
 *
 * Send debug messages to firebug console or alert boxes
 * 
 * @param   str_pMessage     		String				The debug message
 */
function __swapSel_debug(str_pMessage) 
{
  if (this.bol_debugToAlert == true)
  {
    // Debug to alert box
    alert(str_pMessage);
  }
  else
  {
    // Debug to firebug console
    console.log(str_pMessage);
  }
}



/** function swapSel_switchItems()
 *
 * Move all / selected items to the 'selection field'
 * 
 * @param   str_pObject     		Object				The swapSel object
 * @param		bol_pState					Boolean				The state to set to
 * @param		bol_pAll						Boolean				Get all elements or just the currently selected iitems
 */ 
function swapSel_switchItems(obj_pObject, bol_pState, bol_pAll)
{
  // Get both select elements
  obj_allTag = document.getElementById(obj_pObject.id + '_all');
  obj_selectedTag = document.getElementById(obj_pObject.id + '_selected');

  // Check if the elements are really select boxes
  if (obj_allTag && (obj_allTag.nodeType == 1) && (obj_allTag.nodeName.toLowerCase() == 'select') &&
    obj_selectedTag && (obj_selectedTag.nodeType == 1) && (obj_selectedTag.nodeName.toLowerCase() == 'select')) 
  {
    // Get selected elements in the "all selection" select box
    if (bol_pState == true)
    {
      arr_selection = obj_pObject.getSelection(obj_allTag, bol_pAll);
    }
    else
    {
      arr_selection = obj_pObject.getSelection(obj_selectedTag, bol_pAll);
    }
  
    if (arr_selection.length > 0) 
    {
      // Set the status of all selected elements to "selected"
      obj_pObject.changeState(arr_selection, bol_pState);
    
      // Rebuild select boxes
      obj_pObject.rebuildSelects();
    
      // Rebuild hidden fields for selection transfer
      obj_pObject.rebuildHiddenFields();
    }
  }
  else 
  {
    obj_pObject.__swapSel_debug("Error: Swap Select can't find the requiered select elements for »" + obj_pObject.id + "«!");
  }
}