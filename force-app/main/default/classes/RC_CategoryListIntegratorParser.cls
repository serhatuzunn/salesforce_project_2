public class RC_CategoryListIntegratorParser {

	public class SubCategoryList_Z {
		public Integer ID {get;set;} 
		public Boolean IsSelected {get;set;} 
		public String DisplayName {get;set;} 
		public String Code {get;set;} 
		public String ImageUri {get;set;} 
		public Boolean IsNotHyperlink {get;set;} 
		public Boolean IsBrandCategory {get;set;} 
		public Boolean HasProduct {get;set;} 
		public Integer Count {get;set;} 
		public List<SubCategoryList> SubCategoryList {get;set;} 

		public SubCategoryList_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ID') {
							ID = parser.getIntegerValue();
						} else if (text == 'IsSelected') {
							IsSelected = parser.getBooleanValue();
						} else if (text == 'DisplayName') {
							DisplayName = parser.getText();
						} else if (text == 'Code') {
							Code = parser.getText();
						} else if (text == 'ImageUri') {
							ImageUri = parser.getText();
						} else if (text == 'IsNotHyperlink') {
							IsNotHyperlink = parser.getBooleanValue();
						} else if (text == 'IsBrandCategory') {
							IsBrandCategory = parser.getBooleanValue();
						} else if (text == 'HasProduct') {
							HasProduct = parser.getBooleanValue();
						} else if (text == 'Count') {
							Count = parser.getIntegerValue();
						} else if (text == 'SubCategoryList') {
							SubCategoryList = arrayOfSubCategoryList(parser);
						} else {
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class SubCategoryList_Y {
		public Integer ID {get;set;} 
		public Boolean IsSelected {get;set;} 
		public String DisplayName {get;set;} 
		public String Code {get;set;} 
		public String ImageUri {get;set;} 
		public Boolean IsNotHyperlink {get;set;} 
		public Boolean IsBrandCategory {get;set;} 
		public Boolean HasProduct {get;set;} 
		public Integer Count {get;set;} 
		public List<SubCategoryList_Z> SubCategoryList {get;set;} 

		public SubCategoryList_Y(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ID') {
							ID = parser.getIntegerValue();
						} else if (text == 'IsSelected') {
							IsSelected = parser.getBooleanValue();
						} else if (text == 'DisplayName') {
							DisplayName = parser.getText();
						} else if (text == 'Code') {
							Code = parser.getText();
						} else if (text == 'ImageUri') {
							ImageUri = parser.getText();
						} else if (text == 'IsNotHyperlink') {
							IsNotHyperlink = parser.getBooleanValue();
						} else if (text == 'IsBrandCategory') {
							IsBrandCategory = parser.getBooleanValue();
						} else if (text == 'HasProduct') {
							HasProduct = parser.getBooleanValue();
						} else if (text == 'Count') {
							Count = parser.getIntegerValue();
						} else if (text == 'SubCategoryList') {
							SubCategoryList = arrayOfSubCategoryList_Z(parser);
						} else {
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class SubCategoryList {

		public SubCategoryList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
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
	public Object Exception_Z {get;set;} // in json: Exception

	public RC_CategoryListIntegratorParser(JSONParser parser) {
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
						Exception_Z = parser.readValueAs(Object.class);
					} else {
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class TreeList {
		public Integer ID {get;set;} 
		public Boolean IsSelected {get;set;} 
		public String DisplayName {get;set;} 
		public String Code {get;set;} 
		public String ImageUri {get;set;} 
		public Boolean IsNotHyperlink {get;set;} 
		public Boolean IsBrandCategory {get;set;} 
		public Boolean HasProduct {get;set;} 
		public Integer Count {get;set;} 
		public List<SubCategoryList_Y> SubCategoryList {get;set;} 

		public TreeList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ID') {
							ID = parser.getIntegerValue();
						} else if (text == 'IsSelected') {
							IsSelected = parser.getBooleanValue();
						} else if (text == 'DisplayName') {
							DisplayName = parser.getText();
						} else if (text == 'Code') {
							Code = parser.getText();
						} else if (text == 'ImageUri') {
							ImageUri = parser.getText();
						} else if (text == 'IsNotHyperlink') {
							IsNotHyperlink = parser.getBooleanValue();
						} else if (text == 'IsBrandCategory') {
							IsBrandCategory = parser.getBooleanValue();
						} else if (text == 'HasProduct') {
							HasProduct = parser.getBooleanValue();
						} else if (text == 'Count') {
							Count = parser.getIntegerValue();
						} else if (text == 'SubCategoryList') {
							SubCategoryList = arrayOfSubCategoryList_Y(parser);
						} else {
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Result {
		public List<TreeList> TreeList {get;set;} 

		public Result(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'TreeList') {
							TreeList = arrayOfTreeList(parser);
						} else {
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static RC_CategoryListIntegratorParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new RC_CategoryListIntegratorParser(parser);
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
	



    private static List<SubCategoryList_Y> arrayOfSubCategoryList_Y(System.JSONParser p) {
        List<SubCategoryList_Y> res = new List<SubCategoryList_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SubCategoryList_Y(p));
        }
        return res;
    }




    private static List<TreeList> arrayOfTreeList(System.JSONParser p) {
        List<TreeList> res = new List<TreeList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new TreeList(p));
        }
        return res;
    }





    private static List<SubCategoryList_Z> arrayOfSubCategoryList_Z(System.JSONParser p) {
        List<SubCategoryList_Z> res = new List<SubCategoryList_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SubCategoryList_Z(p));
        }
        return res;
    }




    private static List<SubCategoryList> arrayOfSubCategoryList(System.JSONParser p) {
        List<SubCategoryList> res = new List<SubCategoryList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SubCategoryList(p));
        }
        return res;
    }


}