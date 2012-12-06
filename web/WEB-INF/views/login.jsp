<%@ include file="/WEB-INF/views/common/include.jsp" %>



<ti:insertDefinition name="main-layout" >

    <ti:putAttribute name="extrastyle">
        <link rel="stylesheet" href='<c:url value="/styles/security.css" />' type="text/css">
    </ti:putAttribute>

	<ti:putAttribute name="extrascript"  value="/WEB-INF/views/login/script_search.jsp" >
	</ti:putAttribute>
        

    <ti:putAttribute name="main">
        <div class="prepend-4 span-16">

            <!-- retrieve current user status -->
            <sec:authentication property="principal" var="principal"/>
            <!-- retrieve openid cookie -->
            <c:set var="openid_cookie" value="esgf.idp.cookie"/>

            <c:choose>
                <c:when test="${principal=='anonymousUser'}">
                  
                    <!-- User is not authenticated -->
                    <p/>
	             	<h1>ESGF Login</h1>
	                                        
				    <!-- the value of the action attribute must be the same as the URL intercepted by the spring security filter  -->
	                <form name="loginForm" action='<c:url value="/j_spring_openid_security_check"/>' > 
<%-- 					<form name="loginForm"> --%>
						<script language="javascript">
							function sanitize() {
								openidElement = document.getElementById("openid_identifier");
								openid = openidElement.value;
								openid = openid.replace("http:","https:")
								               .replace(/^\s\s*/, '').replace(/\s\s*$/, '');
								openidElement.value = openid;								
								var credential_controller_url = '/esgf-web-fe/credential_proxy';
								
								var queryStr = {'openid' : openid};
								
						        jQuery.ajax({
						        	  url: credential_controller_url,
						        	  query: queryStr,
						        	  async: false,
						        	  type: 'GET',
						        	  success: function(data) {   

						        		  ESGF.localStorage.remove('GO_Credential',data.credential['openid_str']);
						        		  
						        		  
						        		  ESGF.localStorage.put('GO_Credential',data.credential['openid_str'],data.credential['credential_str']);
						        		  
						        		  ESGF.localStorage.printMap('GO_Credential');

										// alert('openid: ' + data.credential['openid_str'] + ' credential: ' + data.credential['credential_str']);
						        	  },
						          	  error: function() {
						          		  // alert('error in getting globus online credential');
						          	  }
						        });
							}
            </script>															    				
	                    <div class="panel">  	                         	
	                    	<c:if test="${param['failed']==true}">
	                    		<span class="myerror">Error: unable to resolve OpenID identifier.</span>
	                		</c:if>                           
	                        <table border="0" align="center">
	                            <tr>
	                                <td align="right" class="required"><b>Openid:</b></td>
	                                <td align="left" style="width:100%">
	                                 	<input type="text" name="openid_identifier" alt="openid text" id="openid_identifier" size="60" value="${cookie[openid_cookie].value}" style="width:100%"/ >
	                                 </td>
	                                <td><input type="submit" alt="openid submit" value="Login" class="button" onclick="javascript:sanitize()"/></td>
	                            </tr>
	                            <tr>
	                                <td>&nbsp;</td>
	                                <td align="center" colspan="2">
	                                    <input type="checkbox" name="remember_openid" checked="checked" alt="openid checkbox" /> <span class="strong">Remember my OpenID</span> on this computer
	                                </td>
	                            </tr>
	                       </table>
	                                   
	                    </div>
	                </form>
	                <p/>
	                <div align="center">Please enter your OpenID. You will be redirected to your registration web site to login.</div>
                  <p/>
                  
                  <div align="center">Not a user? Register <a href='<c:url value="/createAccount"/>' >here</a>.</div>
                  
                  <div align="center">Forgot Openid? Click <a href="javascript:toggle()" id="user">here</a>.</div>
                  <div align="center" id="username" style="display:none">
                    <div class="panel">
                      <p> Please provide the email associated with the forgotten openid.</p>
                      <table><tr>
                        <td><b>Email:</b></td>
                        <td><input type="text" id="usnemail" name="usnemail" size="60" style="width:100%" /></td>
                        <td><input type="submit" value="Submit" class="button" onclick="javascript:findusername()"/></td>
                      </tr></table>
                  </div>
                </div>

               <div align="center">Forgot Password? Click <a href="javascript:roggle()" id="pass">here</a>.</div>
                  <div align="center" id="password" style="display:none">
                    <div class="panel">
                      <p>Please provide your openid. You will recieve a temporary password by email.<br/>Please remember to change your password the next time you login.</p>
                      <table><tr>
                          <td><b>Openid:</b></td>
                          <td> <input type="text" id="pwdopenid" name="pwdopenid" size="60" style="width:100%" /></td>
                          <td><input type="submit" value="Submit" class="button" onclick="javascript:findpassword()"/></td>
                    </tr></table>
                    </div>
                  </div>

                  <div class="error" align="center" style="display: none"></div>
		              <div class="success" align="center" style="display: none"></div>

                  <script language="javascript"> 
                    // MBH: start of retrieve username or password
                    function toggle() {
	                    var usr = document.getElementById("username");
	                    if(usr.style.display == "block") {
    		                usr.style.display = "none";
                        $("div .success").hide();
		    			          $("div .error").hide();
  	                  }
	                    else {
		                    usr.style.display = "block";
	                      $("div .success").hide();
  		    			        $("div .error").hide();
                      }
                    } 

                    function roggle() {
	                    var pwd = document.getElementById("password");
	                    if(pwd.style.display == "block") {
    		                pwd.style.display = "none";
                        $("div .success").hide();
		    			          $("div .error").hide();    
  	                  }
	                    else {
		                    pwd.style.display = "block";
	                      $("div .success").hide();
		    			          $("div .error").hide();
                      }
                    }

                    function findusername() {
                      $("div .success").hide();
		    			        $("div .error").hide();
                      var email = document.getElementById("usnemail").value;
                      var jsonObj = new Object;
			                jsonObj.email = email;			
			                var jsonStr = JSON.stringify(jsonObj);
                      var userinfo_url = '/esgf-web-fe/getopenidsproxy';
                      $.ajax({
	    		              type: "POST",
	    		              url: userinfo_url,
				                async: true,
				                cache: false,
	    		              data: {query:jsonStr},
	    	  	            dataType: 'json',
                        statusCode: {
                          404: function(){
                            alert("page note found");
                          }},
	    		              success: function(data) {
	    			              if (data.EditOutput.status == "success") {
                            var split = data.EditOutput.comment.split('][');
                            var size = split.length;
                            if(size > 2){
                              var print = "<u>These are all the Openids you have on this node:</u> <br/>";
                              for(i = 1; i < (size - 1); i++){
                                print = print + split[i] + "<br/>";
                              }
                            }
                            else{
                              var print = "<font color='red'>This email: " + email + " is not registered on this node</font>"; 
                            }
                            document.getElementById("usnemail").value="";
		    			              $("div .success").html(print);
		    			              $("div .success").show();
		    			              $("div .error").hide();
	    			              } else {
	    				              $("div .error").html("Error");
	    				              $("div .error").show();
	    				              $("div .success").hide();
	    			              }
	    		              },
				                error: function(request, status, error) {
					                alert('request: ' + request + ' status: ' + status + ' error: ' + error);
                          $("div .error").html("Error Three");
					                $("div .error").show();
					                $("div .success").hide();
				                }
			                });
                    }

                    function findpassword() {
                      $("div .success").hide();
		    			        $("div .error").hide();
                      var openid = document.getElementById("pwdopenid").value;
                      var jsonObj = new Object;
                      jsonObj.openid = openid;      
			                var jsonStr = JSON.stringify(jsonObj);
                      var userinfo_url = '/esgf-web-fe/forgotpasswordproxy';
                      $.ajax({
	    		              type: "POST",
	    		              url: userinfo_url,
				                async: true,
				                cache: false,
	    		              data: {query:jsonStr},
	    	  	            dataType: 'json',
                        statusCode: {
                          404: function(){
                            alert("page note found");
                          }},
	    		              success: function(data) {
	    			              if (data.EditOutput.status == "success") {
                            document.getElementById("pwdopenid").value="";
		    			              $("div .success").html(data.EditOutput.comment);
		    			              $("div .success").show();
		    			              $("div .error").hide();
	    			              } else {
	    				              $("div .error").html("Error");
	    				              $("div .error").show();
	    				              $("div .success").hide();
	    			              }
	    		              },
				                error: function(request, status, error) {
					                alert('request: ' + request + ' status: ' + status + ' error: ' + error);
                          $("div .error").html("Error Three");
					                $("div .error").show();
					                $("div .success").hide();
				                }
			                });

                    }
                  </script>
            <p/>
                </c:when>

                <c:otherwise>
                  <c:redirect url="/accountsview"/>
					        
                  <h1>ESGF Logout</h1>
                    <!-- User is authenticated -->
                    <table align="center">
                        <tr>
                            <td align="center" valign="top">
                                <div class="panel">
                                    Thanks, you are now logged in.
                                    <!-- <p/><span class="openidlink">&nbsp;</span> Your OpenID : <b><c:out value="${principal.username}"/></b> -->
                                    <form name="logoutForm" action='<c:url value="/j_spring_security_logout"/>'>
                                        <input type="submit" value="Logout" class="button"/>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </table>
                </c:otherwise>

            </c:choose>

        </div>
    </ti:putAttribute>

</ti:insertDefinition>
