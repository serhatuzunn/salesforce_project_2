//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//
// The supplied json has fields with names that are not valid in apex
// and so can only be parsed with explicitly generated code, this option
// was auto selected for you.

public class RC_Rnbx_ProductIntegratorParser {

	public class CustomValueAttributeList {

		public CustomValueAttributeList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'CustomValueAttributeList consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class VisibleAttributeList {
		public String ID {get;set;} 
		public String ProductID {get;set;} 
		public String VariantID {get;set;} 
		public String AttributeID {get;set;} 
		public String AttributeOptionID {get;set;} 
		public String AttributeOptionCode {get;set;} 
		public String OptionDisplayOrder {get;set;} 
		public String CustomValueText {get;set;} 
		public String Style {get;set;} 
		public String Description {get;set;} 
		public String CodeName {get;set;} 
		public String DisplayName {get;set;} 
		public String DisplayOrder {get;set;} 
		public Boolean IsVariant {get;set;} 
		public Boolean IsFilter {get;set;} 
		public Boolean IsDetailAtribute {get;set;} 
		public Boolean IsSearchAttribute {get;set;} 
		public Boolean IsImageSwitcher {get;set;} 
		public Boolean IsLookup {get;set;} 
		public Boolean IsVisibleToCustomer {get;set;} 
		public Boolean IsTemplateAttribute {get;set;} 
		public String ValueText {get;set;} 
		public String AttributeLogo {get;set;} 
		public Boolean IsClassification {get;set;} 
		public String ActualValueText {get;set;} 
		public String Quantity {get;set;} 
		public String ImageUrl {get;set;} 

		public VisibleAttributeList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ID') {
							ID = parser.getText();
						} else if (text == 'ProductID') {
							ProductID = parser.getText();
						} else if (text == 'VariantID') {
							VariantID = parser.getText();
						} else if (text == 'AttributeID') {
							AttributeID = parser.getText();
						} else if (text == 'AttributeOptionID') {
							AttributeOptionID = parser.getText();
						} else if (text == 'AttributeOptionCode') {
							AttributeOptionCode = parser.getText();
						} else if (text == 'OptionDisplayOrder') {
							OptionDisplayOrder = parser.getText();
						} else if (text == 'CustomValueText') {
							CustomValueText = parser.getText();
						} else if (text == 'Style') {
							Style = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'CodeName') {
							CodeName = parser.getText();
						} else if (text == 'DisplayName') {
							DisplayName = parser.getText();
						} else if (text == 'DisplayOrder') {
							DisplayOrder = parser.getText();
						} else if (text == 'IsVariant') {
							IsVariant = parser.getBooleanValue();
						} else if (text == 'IsFilter') {
							IsFilter = parser.getBooleanValue();
						} else if (text == 'IsDetailAtribute') {
							IsDetailAtribute = parser.getBooleanValue();
						} else if (text == 'IsSearchAttribute') {
							IsSearchAttribute = parser.getBooleanValue();
						} else if (text == 'IsImageSwitcher') {
							IsImageSwitcher = parser.getBooleanValue();
						} else if (text == 'IsLookup') {
							IsLookup = parser.getBooleanValue();
						} else if (text == 'IsVisibleToCustomer') {
							IsVisibleToCustomer = parser.getBooleanValue();
						} else if (text == 'IsTemplateAttribute') {
							IsTemplateAttribute = parser.getBooleanValue();
						} else if (text == 'ValueText') {
							ValueText = parser.getText();
						} else if (text == 'AttributeLogo') {
							AttributeLogo = parser.getText();
						} else if (text == 'IsClassification') {
							IsClassification = parser.getBooleanValue();
						} else if (text == 'ActualValueText') {
							ActualValueText = parser.getText();
						} else if (text == 'Quantity') {
							Quantity = parser.getText();
						} else if (text == 'ImageUrl') {
							ImageUrl = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'VisibleAttributeList consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ImageSetList {
		public List<ImageList> ImageList {get;set;} 

		public ImageSetList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ImageList') {
							ImageList = arrayOfImageList(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ImageSetList consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class AttributeGroupList {
		public String ID {get;set;} 
		public String AttributeOptionID {get;set;} 
		public String SubAttributeOptionID {get;set;} 
		public String Code {get;set;} 
		public String DisplayName {get;set;} 
		public String Description {get;set;} 
		public List<AttributeGroupItemList> AttributeGroupItemList {get;set;} 

		public AttributeGroupList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ID') {
							ID = parser.getText();
						} else if (text == 'AttributeOptionID') {
							AttributeOptionID = parser.getText();
						} else if (text == 'SubAttributeOptionID') {
							SubAttributeOptionID = parser.getText();
						} else if (text == 'Code') {
							Code = parser.getText();
						} else if (text == 'DisplayName') {
							DisplayName = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'AttributeGroupItemList') {
							AttributeGroupItemList = arrayOfAttributeGroupItemList(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'AttributeGroupList consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Boolean Success {get;set;} 
	public String Message {get;set;} 
	public Result Result {get;set;} 
	public String Exception_Z {get;set;} // in json: Exception

	public RC_Rnbx_ProductIntegratorParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Success') {
						Success = parser.getBooleanValue();
					} else if (text == 'Message') {
						Message = parser.getText();
					} else if (text == 'Result') {
						Result = new Result(parser);
					} else if (text == 'Exception') {
						Exception_Z = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'RC_Rnbx_ProductIntegratorParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class SelectionList {
		public String CodeName {get;set;} 
		public String DisplayName {get;set;} 
		public String DisplayOrder {get;set;} 
		public List<OptionList> OptionList {get;set;} 
		public Boolean IsSingleChoice {get;set;} 

		public SelectionList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'CodeName') {
							CodeName = parser.getText();
						} else if (text == 'DisplayName') {
							DisplayName = parser.getText();
						} else if (text == 'DisplayOrder') {
							DisplayOrder = parser.getText();
						} else if (text == 'OptionList') {
							OptionList = arrayOfOptionList(parser);
						} else if (text == 'IsSingleChoice') {
							IsSingleChoice = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'SelectionList consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class AttributeGroupItemList {
		public String ID {get;set;} 
		public String AttributeGroupID {get;set;} 
		public String AttributeID {get;set;} 
		public String AttributeName {get;set;} 
		public String AttributeValueText {get;set;} 
		public Boolean IsSameValue {get;set;} 

		public AttributeGroupItemList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ID') {
							ID = parser.getText();
						} else if (text == 'AttributeGroupID') {
							AttributeGroupID = parser.getText();
						} else if (text == 'AttributeID') {
							AttributeID = parser.getText();
						} else if (text == 'AttributeName') {
							AttributeName = parser.getText();
						} else if (text == 'AttributeValueText') {
							AttributeValueText = parser.getText();
						} else if (text == 'IsSameValue') {
							IsSameValue = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'AttributeGroupItemList consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class OptionList {
		public String AttributeOptionID {get;set;} 
		public String VariantID {get;set;} 
		public String CodeName {get;set;} 
		public String ValueText {get;set;} 
		public String DisplayOrder {get;set;} 
		public Boolean NoStock {get;set;} 
		public String Barcode {get;set;} 
		public String Quantity {get;set;} 

		public OptionList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AttributeOptionID') {
							AttributeOptionID = parser.getText();
						} else if (text == 'VariantID') {
							VariantID = parser.getText();
						} else if (text == 'CodeName') {
							CodeName = parser.getText();
						} else if (text == 'ValueText') {
							ValueText = parser.getText();
						} else if (text == 'DisplayOrder') {
							DisplayOrder = parser.getText();
						} else if (text == 'NoStock') {
							NoStock = parser.getBooleanValue();
						} else if (text == 'Barcode') {
							Barcode = parser.getText();
						} else if (text == 'Quantity') {
							Quantity = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'OptionList consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ImageList {
		public String Path {get;set;} 
		public String SizeCode {get;set;} 
		public String Width {get;set;} 
		public String Height {get;set;} 
		public String AltText {get;set;} 
		public String Title {get;set;} 

		public ImageList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Path') {
							Path = parser.getText();
						} else if (text == 'SizeCode') {
							SizeCode = parser.getText();
						} else if (text == 'Width') {
							Width = parser.getText();
						} else if (text == 'Height') {
							Height = parser.getText();
						} else if (text == 'AltText') {
							AltText = parser.getText();
						} else if (text == 'Title') {
							Title = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ImageList consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Result {
		public String ID {get;set;} 
		public String ActualPriceToShowOnScreen {get;set;} 
		public String BrandName {get;set;} 
		public String Description {get;set;} 
		public String DisplayName {get;set;} 
		public String ProductType {get;set;} 
		public String ExternalSystemCode {get;set;} 
		public String CategoryID {get;set;} 
		public String CategoryName {get;set;} 
		public Boolean IsStrikeThroughPriceExists {get;set;} 
		public Boolean IsClickAndCollect {get;set;} 
		public String PageTitle {get;set;} 
		public String FirstProductImageURL {get;set;} 
		public String StrikeThroughPriceToShowOnScreen {get;set;} 
		public String DiscountRate {get;set;} 
		public String ShareUrl {get;set;} 
		public List<VisibleAttributeList> VisibleAttributeList {get;set;} 
		public List<CustomValueAttributeList> CustomValueAttributeList {get;set;} 
		public List<SelectionList> SelectionList {get;set;} 
		public List<ImageSetList> ImageSetList {get;set;} 
		public String MatchedVariantID {get;set;} 
		public Boolean IsOutOfStock {get;set;} 
		public Boolean IsPreOrder {get;set;} 
		public String EstimatedSupplyDate {get;set;} 
		public List<CustomValueAttributeList> ParsedProductDetails {get;set;} 
		public List<CustomValueAttributeList> OtherColorOfProductList {get;set;} 
		public List<AttributeGroupList> AttributeGroupList {get;set;} 
		public String Warrantly {get;set;} 
		public List<CustomValueAttributeList> ProductCommentList {get;set;} 
		public List<CustomValueAttributeList> AttributeContentList {get;set;} 

		public Result(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ID') {
							ID = parser.getText();
						} else if (text == 'ActualPriceToShowOnScreen') {
							ActualPriceToShowOnScreen = parser.getText();
						} else if (text == 'BrandName') {
							BrandName = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'DisplayName') {
							DisplayName = parser.getText();
						} else if (text == 'ProductType') {
							ProductType = parser.getText();
						} else if (text == 'ExternalSystemCode') {
							ExternalSystemCode = parser.getText();
						} else if (text == 'CategoryID') {
							CategoryID = parser.getText();
						} else if (text == 'CategoryName') {
							CategoryName = parser.getText();
						} else if (text == 'IsStrikeThroughPriceExists') {
							IsStrikeThroughPriceExists = parser.getBooleanValue();
						} else if (text == 'IsClickAndCollect') {
							IsClickAndCollect = parser.getBooleanValue();
						} else if (text == 'PageTitle') {
							PageTitle = parser.getText();
						} else if (text == 'FirstProductImageURL') {
							FirstProductImageURL = parser.getText();
						} else if (text == 'StrikeThroughPriceToShowOnScreen') {
							StrikeThroughPriceToShowOnScreen = parser.getText();
						} else if (text == 'DiscountRate') {
							DiscountRate = parser.getText();
						} else if (text == 'ShareUrl') {
							ShareUrl = parser.getText();
						} else if (text == 'VisibleAttributeList') {
							VisibleAttributeList = arrayOfVisibleAttributeList(parser);
						} else if (text == 'CustomValueAttributeList') {
							CustomValueAttributeList = arrayOfCustomValueAttributeList(parser);
						} else if (text == 'SelectionList') {
							SelectionList = arrayOfSelectionList(parser);
						} else if (text == 'ImageSetList') {
							ImageSetList = arrayOfImageSetList(parser);
						} else if (text == 'MatchedVariantID') {
							MatchedVariantID = parser.getText();
						} else if (text == 'IsOutOfStock') {
							IsOutOfStock = parser.getBooleanValue();
						} else if (text == 'IsPreOrder') {
							IsPreOrder = parser.getBooleanValue();
						} else if (text == 'EstimatedSupplyDate') {
							EstimatedSupplyDate = parser.getText();
						} else if (text == 'ParsedProductDetails') {
							ParsedProductDetails = arrayOfCustomValueAttributeList(parser);
						} else if (text == 'OtherColorOfProductList') {
							OtherColorOfProductList = arrayOfCustomValueAttributeList(parser);
						} else if (text == 'AttributeGroupList') {
							AttributeGroupList = arrayOfAttributeGroupList(parser);
						} else if (text == 'Warrantly') {
							Warrantly = parser.getText();
						} else if (text == 'ProductCommentList') {
							ProductCommentList = arrayOfCustomValueAttributeList(parser);
						} else if (text == 'AttributeContentList') {
							AttributeContentList = arrayOfCustomValueAttributeList(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Result consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static RC_Rnbx_ProductIntegratorParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new RC_Rnbx_ProductIntegratorParser(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	
    private static List<AttributeGroupList> arrayOfAttributeGroupList(System.JSONParser p) {
        List<AttributeGroupList> res = new List<AttributeGroupList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new AttributeGroupList(p));
        }
        return res;
    }





    private static List<ImageSetList> arrayOfImageSetList(System.JSONParser p) {
        List<ImageSetList> res = new List<ImageSetList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ImageSetList(p));
        }
        return res;
    }



    private static List<OptionList> arrayOfOptionList(System.JSONParser p) {
        List<OptionList> res = new List<OptionList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new OptionList(p));
        }
        return res;
    }



    private static List<AttributeGroupItemList> arrayOfAttributeGroupItemList(System.JSONParser p) {
        List<AttributeGroupItemList> res = new List<AttributeGroupItemList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new AttributeGroupItemList(p));
        }
        return res;
    }



    private static List<CustomValueAttributeList> arrayOfCustomValueAttributeList(System.JSONParser p) {
        List<CustomValueAttributeList> res = new List<CustomValueAttributeList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new CustomValueAttributeList(p));
        }
        return res;
    }


    private static List<ImageList> arrayOfImageList(System.JSONParser p) {
        List<ImageList> res = new List<ImageList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ImageList(p));
        }
        return res;
    }






    private static List<SelectionList> arrayOfSelectionList(System.JSONParser p) {
        List<SelectionList> res = new List<SelectionList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SelectionList(p));
        }
        return res;
    }




    private static List<VisibleAttributeList> arrayOfVisibleAttributeList(System.JSONParser p) {
        List<VisibleAttributeList> res = new List<VisibleAttributeList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new VisibleAttributeList(p));
        }
        return res;
    }


}