<%@ include file="/WEB-INF/views/common/include.jsp" %>

<form id="new_user_form" action="goformview2" method="post" >
	<h3 style="" id="form_title">Form 1 Info</h3>
				
	<table id="adduser_table_id" class="adduser_table" >  
		<tr id="userName_input">
			<td>
				<div class="adduser_properties" style="">Globus Online Username</div> 
			</td>
			<td>
				<input type="text" class="text" id="goUserName" name="goUserName" value=""> 
			</td>
		</tr>
		<tr>
			<td>
				<div class="adduser_properties" style="">MyProxy Source Username</div>
			</td>
			<td>
				<input type="text" class="text" name="myProxyUserName" id="myProxyUserName" value=""> 
			</td>
		</tr>
		<tr>
			<td>
				<div class="adduser_properties" style="">MyProxy Source Password</div>
			</td>
			<td>
				<input type="password" class="text" name="myProxyUserPass" id="myProxyUserPass" value=""> 
			</td>
		</tr>
    </table>
    <p>
    <input type="checkbox" name="goEmail" value="goEmail" /> Email when transfer starts<br />
    </p>
    
    <p>
      	<%-- Input params to go_form2 
      	goUserName -> Globus Online User Name
      	myProxyUserName -> username of the source myproxy
      	myProxyUserPass -> userpass of the source myproxy
      	id -> DatasetName
      	child_id[] -> FileNames
      	child_url[] -> FileUrls
      	goEmail -> toggler for sending email confirmation
      	--%>
      	<input type="hidden" name="id" id="${GoFormView_Dataset_Name}" value="${GoFormView_Dataset_Name}" />
	  	<c:set var="j" value="0"/>
      	<c:forEach var="group" items="${GoFormView_File_Names}">
      		<input type="hidden" name="child_id" id="${GoFormView_File_Names[j]}" value="${GoFormView_File_Names[j]}" />
      		<input type="hidden" name="child_url" id="${GoFormView_File_Urls[j]}" value="${GoFormView_File_Urls[j]}" />
      			
	  		<c:set var="j" value="${j+1}"/>
     	</c:forEach>
	  	
     	<input style="" class="adminbutton" type="submit" value="next">
	</p>
</form>