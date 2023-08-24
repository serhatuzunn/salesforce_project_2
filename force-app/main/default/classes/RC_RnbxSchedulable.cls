global class RC_RnbxSchedulable implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        RC_CategoryListIntegrator.ResponseModel responseCategoryList = RC_CategoryListIntegrator.getCategoryList();
        system.debug('responseCategoryList.CategoryListResponse.Result.TreeList : ' + responseCategoryList.CategoryListResponse.Result.TreeList);
        
        
        Set<Integer> categorySet = new Set<Integer>();
        
        for(RC_CategoryListIntegratorParser.TreeList sub1treeListItem : responseCategoryList.CategoryListResponse.Result.TreeList){         //1.kırılım
            //system.debug('sub1treeListItem : ' + sub1treeListItem);
            
            if(sub1treeListItem.SubCategoryList.size() == 0){    
                categorySet.add(sub1treeListItem.ID);
            }   
            else{                                                           
                for(RC_CategoryListIntegratorParser.SubCategoryList_Y sub2treeListItem : sub1treeListItem.SubCategoryList){                  //2.kırılım
                    //system.debug('sub2treeListItem : ' + sub2treeListItem);
                    if(sub2treeListItem.SubCategoryList.size() == 0){
                        categorySet.add(sub2treeListItem.ID);
                    }
                    else{
                        for(RC_CategoryListIntegratorParser.SubCategoryList_Z sub3treeListItem : sub2treeListItem.SubCategoryList){        //3. kırılım  
                            //system.debug('sub3treeListItem : ' + sub3treeListItem);
                            if(sub3treeListItem.SubCategoryList.size() == 0){
                                categorySet.add(sub3treeListItem.ID);
                            }
                            else{
                                system.debug('HATA : 4.kırılıma göre düzenleme yapılması gerekmektedir.');
                                RC_Logger.LOG_EXCEPTION('Error : RC_RnbxSchedulable', 'HATA : 4.kırılım', 'HATA : 4.kırılıma göre düzenleme yapılması gerekmektedir.', 'RC_RnbxSchedulable', 'execute', '');

                            }
                        }
                    }
                    
                }
            }
        }
        system.debug('categorySet.size() : ' + categorySet.size());
        system.debug('categorySet : ' + categorySet);
        
        RC_ProductListQueueable productListQueueable = new RC_ProductListQueueable(categorySet);
        // enqueue the job for processing
        ID jobID = System.enqueueJob(productListQueueable);
        system.debug('jobID : ' + jobID);
        
    }
}