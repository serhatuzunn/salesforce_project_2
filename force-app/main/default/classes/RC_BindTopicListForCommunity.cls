global class RC_BindTopicListForCommunity extends VisualEditor.DynamicPickList{
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Select', 'Select');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        
        
        List<Topic> topics = [SELECT Name FROM Topic];
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        for(Topic t : topics)
        {
            
            VisualEditor.DataRow item = new VisualEditor.DataRow(t.Name, t.Name);
            myValues.addRow(item);
            
        }
         VisualEditor.DataRow itemSelect = new VisualEditor.DataRow('Select', 'Select');
            myValues.addRow(itemSelect);
        return myValues;
    }
}