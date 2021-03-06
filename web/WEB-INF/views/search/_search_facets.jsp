<!-- Search facets accordions -->
<%@ include file="/WEB-INF/views/common/include.jsp" %>

<h2>Categories</h2>


<c:if test="${search_output.facets != null}">
<ul class="menu noaccordion">

<c:forEach var="entry" items="${search_output.facets}">

    <c:set var="selected" value="" />
    
    <c:if test="${not empty search_input.constraints[entry.key]}">
        <c:set var="selected" value="selected"/>
    </c:if>

    <c:choose>
    <c:when test="${fn:length(entry.value.subFacets)>0}">
       <li class="enabled"><a href="#"><c:out value="${facet_profile.topLevelFacets[entry.key].label}"/></a>
    </c:when>
    
    <c:otherwise>
       <li class="disabled"><c:out value="${facet_profile.topLevelFacets[entry.key].label}"/>
    </c:otherwise>
    </c:choose> 
       
    <ul class="acitem">
       <c:choose>                                                          
          <c:when test="${not empty search_input.constraints[entry.key]}">    
          <!-- facet has been selected > include selected option and backup link -->
          <li><a href='javascript:resetFacet("${entry.key}")'>
          Any <c:out value="${entry.value.label}"/></a></li>
               <c:forEach var="subFacet" items="${entry.value.subFacets}">
               <li class="selected"><c:out value="${subFacet.label}"/> 
               (<c:out value="${subFacet.counts}"/>)</li>
              </c:forEach>
         </c:when>                               
         <c:otherwise>
         <!-- facet not selected > include all options -->
            <c:forEach var="subFacet" items="${entry.value.subFacets}">
                   <li class="none">
                   <a href='javascript:setFacet("${entry.key}", "${subFacet.label}")'>
                       <span id="entry_key" style="display:none">
                         <c:out value="${entry.key}"/></span>
                       <span id="subfacet_label">
                         <c:out value="${subFacet.label}"/></span>
                      (<c:out value="${subFacet.counts}"/>)</a></li>
            </c:forEach>
         </c:otherwise>
       </c:choose>
       </ul> 
       
       </li>
       
</c:forEach>

</ul>
</c:if>
