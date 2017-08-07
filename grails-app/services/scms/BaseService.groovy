package scms

import grails.util.Environment
import grid.FilterOperator
import grid.FilterOption
import groovy.sql.GroovyRowResult
import org.codehaus.groovy.grails.commons.DefaultGrailsDomainClass
import org.codehaus.groovy.grails.commons.GrailsDomainClassProperty
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap
import org.hibernate.SQLQuery
import org.hibernate.Session
import scms.utility.Tools

import javax.sql.DataSource

class BaseService extends Tools {

    def sessionFactory
    def groovySql
    def groovySql_mis
    def groovySql_comn
    static transactional = false

    public final static int DEFAULT_RESULT_PER_PAGE = 10;
    public final static String DESCENDING_SORT_ORDER = "desc";
    public final static String ASCENDING_SORT_ORDER = "asc";
    public final static String DEFAULT_SORT_ORDER = DESCENDING_SORT_ORDER


    public final static String PAGE_PARAM = "page";
    public final static String RESULT_PER_PAGE_PARAM = "rp";
    public final static String RESULT_PER_PAGE_KENDO = "take";
    public final static String OFFSET_KENDO = "skip";
    public final static String SORT_COLUMN_KENDO = "sort[0][field]";
    public final static String SORT_ORDER_KENDO = "sort[0][dir]";
    public final static String CURRENT_COUNT_ON_PAGE_PARAM = "currentCount";
    private final static String DEFAULT_FALSE_PARAM = 'false'
    public final static String ID = "id";
    public final static String NAME = "name";
    public final static String DEFAULT_SORT_COLUMN = ID;
    public final
    static String ENTITY_NOT_FOUND_ERROR_MESSAGE = "No entity found with this id or might have been deleted by someone!";
    int pageNumber = 1;
    int currentCount = 0;
    int resultPerPage = DEFAULT_RESULT_PER_PAGE;
    String sortColumn = DEFAULT_SORT_COLUMN;
    String sortOrder = DEFAULT_SORT_ORDER;
    int start;

    // for single search
    String queryType;
    String query;

    // for combined search
    List<String> lstQueryType = []
    List<String> lstQuery = []

    private static final String EXECUTING_SQL = " SQL : "
    private static final String EXECUTING_CONTENT = " CONTENT : "
    private static final String VALUES = " Values : "
    private static final String COMPANY_ID_COLUMN = "companyId";

    DataSource dataSource;

    // Kendo filter options
    Map<Long, FilterOption> filterOptions;

    public List executeInsertSql(String query) {
        consolePrint(query)
        return groovySql.executeInsert(query)
    }

    public List executeInsertSql(String query, Map params) {
        consolePrint(query)
        return groovySql.executeInsert(query, params)
    }

    public int executeUpdateSql(String query) {
        consolePrint(query)
        return groovySql.executeUpdate(query)
    }

    public int executeUpdateSql(String query, Map params) {
        consolePrint(query, params)
        return groovySql.executeUpdate(query, params)
    }

    public boolean executeSql(String query) {
        consolePrint(query)
        return groovySql.execute(query)
    }

    public boolean executeSql(String query, Map params) {
        consolePrint(query, params)
        return groovySql.execute(query, params)
    }

    public List<GroovyRowResult> executeSelectSql(String query) {
        consolePrint(query, null)
        return groovySql.rows(query)
    }

    public List<GroovyRowResult> executeSelectSql(String query, Map params) {
        consolePrint(query, params)
        return groovySql.rows(query, params)
    }

    public List getEntityList(String queryStr, Class entity) {
        Session session = sessionFactory.currentSession
        SQLQuery query = session.createSQLQuery(queryStr);
        query.addEntity(entity);
        query.setReadOnly(true);
        consolePrint(queryStr, null);
        return query.list();
    }

    // ... and add executeDeleteSql, executeInsertSql, count and so on as needed.
    private Environment currentEnv = Environment.current

    protected void consolePrint(String query, Object params) {
        if (currentEnv == Environment.DEVELOPMENT) {
            println "${EXECUTING_SQL}${query}}"
            if (params) println "${VALUES}${params.toString()}"
        }
    }

    protected void consolePrint(String content) {
        if (currentEnv == Environment.DEVELOPMENT) {
            println "${EXECUTING_CONTENT}${content}"
        }
    }

    public Object formatValidationErrorsForUI(Object entity, Closure formatErrorMessage, boolean addAllErrorsIfOccurred) {

        def errors = []
        entity.errors.allErrors.each {
            errors << [it.field, formatErrorMessage(it)/*g.message(error: it)*/]
        }

        if (addAllErrorsIfOccurred) { // will include all errors in result
            return [isError: true, entity: entity, errors: errors, allErrors: entity.errors.allErrors]
        } else {
            return [isError: true, entity: entity, errors: errors]
        }

    }

    /**
     * Initializes list/filter related request parameters for kendo grid
     * @param params request parameters
     */
    void initListing(GrailsParameterMap params) {

        initPagination(params);
        initSorting(params);

        resetFilter();
        parseFilterParams(params);

    }

    /**
     * Parses the request parameters to see if filter options are sent
     * from the browser; if so, it wraps each filter option in FilterOption
     * object which contains the following information:
     * <ul>
     *     <li>Field: Name of the filter to be filtered (hence Domain property)</li>
     *     <li>Operator: Filter operator to be used (e.g., eq for EQUAl, gt for GREATER THAN etc.)</li>
     *     <li>Value: Value to be sought while searching domains</li>
     * </ul>
     *
     * @param params request parameters
     */
    private void parseFilterParams(GrailsParameterMap params) {

        def indexerPattern = ~/(\[\d+\])(\[.*\])/;
        def pattern = ~/filter\[filters\].*/;
        this.filterOptions = new HashMap<Long, FilterOption>();
        Iterator<Map.Entry<String, String>> iterator = params.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<String, String> entry = iterator.next();
            String name = entry.key.toString();
            if (pattern.matcher(name).matches()) {
                String prop = name.replaceFirst(/filter\[filters\]/, '');
                def matcher = indexerPattern.matcher(prop);
                if (matcher.matches()) {
                    String index = matcher.group(1).replaceAll(~/\[|\]/, '');
                    String property = matcher.group(2).replaceAll(~/\[|\]/, '');

                    Long optionKey = index.toLong();
                    FilterOption filter = filterOptions.get(optionKey);
                    if (!filter) {
                        filter = new FilterOption();
                        filterOptions.put(optionKey, filter);
                    }

                    try {
                        FilterOption.getField(property).set(filter, entry.value.trim());
                    } catch (Exception ignored) {
                        ignored.printStackTrace();
                    }
                }
            }
        }

    }

    /**
     * Initializes pagination attributes, such as how many records to return
     * and query offset
     *
     * @param params Request parameters
     */
    private void initPagination(GrailsParameterMap params) {
        if(params.take=="false"){
            this.resultPerPage =0
        } else{
            this.resultPerPage = params.int(RESULT_PER_PAGE_KENDO)?params.int(RESULT_PER_PAGE_KENDO):15
        }
        this.start = params.int(OFFSET_KENDO)?params.int(OFFSET_KENDO):0
    }

    /**
     * Initializes sort options for object list, such as which column to sort in which order
     *
     * @param params Request parameters
     */
    private void initSorting(GrailsParameterMap params) {
        this.sortColumn = params.get(SORT_COLUMN_KENDO) ? params.get(SORT_COLUMN_KENDO) : DEFAULT_SORT_COLUMN
        this.sortOrder = params.get(SORT_ORDER_KENDO) ? params.get(SORT_ORDER_KENDO) : DEFAULT_SORT_ORDER
    }

    /**
     * Resets filter options
     */
    private void resetFilter() {
        if (this.filterOptions != null) {
            this.filterOptions.clear();
        }
    }

    /**
     * A grid is being filtered only when there are filter options mapped in this.filterOptions
     *
     * @return true if there is at least one FilterOption in this.filterOptions, false otherwise
     */
    protected boolean isFiltering() {
        return (this.filterOptions != null && this.filterOptions.size() > 0);
    }

    /**
     * Lists domain objects, return a subset of the list based on
     * record size per page. It also sorts the result based on
     * sort column and order
     *
     * @param domainClass Domain class instance to be listed
     * @return list of domains
     */
    protected Map listForGrid(Class domainClass, Closure additionalFilter) {
        DefaultGrailsDomainClass gClass = new DefaultGrailsDomainClass(domainClass)
        List lst = domainClass.withCriteria {
            if (additionalFilter) {
                additionalFilter.delegate = delegate
                additionalFilter()
            }
            if(this.resultPerPage>0) maxResults(this.resultPerPage)
            firstResult(this.start)
            order(this.sortColumn, this.sortOrder)
            setReadOnly(true)
        } as List;

        // Count query for the above criteria using projection
        List counts = domainClass.withCriteria {
            if (additionalFilter) {
                additionalFilter.delegate = delegate
                additionalFilter()
            }
            projections { rowCount() };
        } as List;

        int total = counts[0] as int;
        return [list: lst, count: total];

    }

    /**
     * Initializes listing attributes such as start offset, result per page and sort column
     * and sort order, then it determines whether teh request is for searching the domains
     * for a given filter criteria or to search all domains, it eitehr filter the domain entity
     * or return list of all domain entities. Domain class is specified by the domainClass param
     *
     * @param params Request parameters
     * @param domainClass Domain class being searched
     * @return Loist of domain objects
     */
    protected Map getSearchResult(Map parameterMap, Class domainClass, Closure additionalFilter = null) {
        GrailsParameterMap params = (GrailsParameterMap) parameterMap
        this.initListing(params)
        Map resultMap = null
        if (this.isFiltering()) {
            resultMap = this.filterForGrid(domainClass, additionalFilter)
        } else {
            resultMap = this.listForGrid(domainClass, additionalFilter)
        }
        return resultMap
    }

    /**
     * Builds dynamic criteria based on filter options mapped in this.filterOptions
     *
     * @see this.parseFilterParams
     *
     * @param domainClass Domain to search using criteria
     * @return List of domains found in search and its total
     */
    protected Map filterForGrid(Class domainClass, Closure additionalFilter) {

        List<FilterOption> filterOptionList = this.filterOptions.values() as List<FilterOption>;

        DefaultGrailsDomainClass gClass = new DefaultGrailsDomainClass(domainClass);
        GrailsDomainClassProperty[] properties = gClass.properties;

        /*      Searches domain with the criteria based on filter options mapped in this.filterOptions
                It dynamically creates conditions based on filter operator sent through the kendo grid
        */
        List lst = domainClass.withCriteria {
            for (FilterOption filterOption : filterOptionList) {
                switch (filterOption.operator) {
                    case FilterOperator.STARTS_WITH:
                        ilike("${filterOption.field}", "${filterOption.value}%")
                        break;

                    case FilterOperator.ENDS_WITH:
                        ilike("${filterOption.field}", "%${filterOption.value}")
                        break;


                    case FilterOperator.CONTAINS:
                        ilike("${filterOption.field}", "%${filterOption.value}%")
                        break;


                    case FilterOperator.DOES_NOT_CONTAIN:
                        not {
                            ilike("${filterOption.field}", "%${filterOption.value}%")
                        }
                        break;

                    case FilterOperator.EQUAL:
                        eq("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;

                    case FilterOperator.NOT_EQUAL:
                        ne("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;

                    case FilterOperator.GREATER_THAN:
                        gt("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;

                    case FilterOperator.GREATER_THAN_OR_EQUAL_TO:
                        gte("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;

                    case FilterOperator.LESS_THAN:
                        lt("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;

                    case FilterOperator.LESS_THAN_OR_EQUAL_TO:
                        lte("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;


                }
            }
            if (additionalFilter) {
                additionalFilter.delegate = delegate
                additionalFilter()
            }
            maxResults(this.resultPerPage)
            firstResult(this.start)
            order(this.sortColumn, this.sortOrder)
            setReadOnly(true)
        } as List;

        // Count query for the above criteria using projection
        List counts = domainClass.withCriteria {
            for (FilterOption filterOption : filterOptionList) {
                switch (filterOption.operator) {
                    case FilterOperator.STARTS_WITH:
                        ilike("${filterOption.field}", "${filterOption.value}%")
                        break;

                    case FilterOperator.ENDS_WITH:
                        ilike("${filterOption.field}", "%${filterOption.value}")
                        break;


                    case FilterOperator.CONTAINS:
                        ilike("${filterOption.field}", "%${filterOption.value}%")
                        break;


                    case FilterOperator.DOES_NOT_CONTAIN:
                        not {
                            ilike("${filterOption.field}", "%${filterOption.value}%")
                        }
                        break;

                    case FilterOperator.EQUAL:
                        eq("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;

                    case FilterOperator.NOT_EQUAL:
                        ne("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;

                    case FilterOperator.GREATER_THAN:
                        gt("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;

                    case FilterOperator.GREATER_THAN_OR_EQUAL_TO:
                        gte("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;

                    case FilterOperator.LESS_THAN:
                        lt("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;

                    case FilterOperator.LESS_THAN_OR_EQUAL_TO:
                        lte("${filterOption.field}", convertValueToType(properties, filterOption.field, filterOption.value.toString()))
                        break;


                }
            }
            if (additionalFilter) {
                additionalFilter.delegate = delegate
                additionalFilter()
            }
            projections { rowCount() };
        } as List;
        int total = counts[0] as int
        return [list: lst, count: total]
    }

    /**
     * Sets result state to indicate error by adding a key "isError" with TRUE value
     *
     * @param resultMap Existing result map where the result state will be put
     * @param message Optional message to be set (e.g., to be shown in UI)
     * @return Same resultMap with a status set
     */
    protected Map setError(Map resultMap, String message) {
        resultMap.put(IS_ERROR, Boolean.TRUE)
        if (message != null) {
            resultMap.put(MESSAGE, message)
        }
        return resultMap
    }

    /**
     * Sets result state to indicate success by adding a key "isError" with FALSE value
     *
     * @param resultMap Existing result map where the result state will be put
     * @param message Optional message to be set (e.g., to be shown in UI)
     * @return Same resultMap with a status set
     */
    protected Map setSuccess(Map resultMap, String message) {
        resultMap.put(IS_ERROR, Boolean.FALSE)
        if (message != null) {
            resultMap.put(MESSAGE, message)
        }
        return resultMap
    }

    /**
     * Cast the given value based on the property type by searching the property type in
     * properties array.
     *
     * @param properties Array of properties (of a domain)
     * @param propertyName Name of the property type  of which will be used to cast the value
     * @param propertyValue Property value being converted
     * @return Converted value
     */
    private Object convertValueToType(GrailsDomainClassProperty[] properties, String propertyName,
                                      String propertyValue) {

        Class propertyType = null;
        for (GrailsDomainClassProperty property : properties) {
            if (property.name.equals(propertyName)) {
                propertyType = property.type;
                break;
            }
        }

        if (propertyType != null) {
            switch (propertyType) {
                case char.class:
                case Character.class:
                    return propertyValue;
                case short.class:
                case byte.class:
                case int.class:
                case Integer.class:
                    return Integer.parseInt(propertyValue);
                case long.class:
                case Long.class:
                    return Long.parseLong(propertyValue);
                case float.class:
                case Float.class:
                    return Float.parseFloat(propertyValue);
                case double.class:
                case Double.class:
                    return Double.parseDouble(propertyValue);
                case boolean.class:
                case Boolean.class:
                    return Boolean.parseBoolean(propertyValue);
                case Date.class:
                    return Date.parse("yyyy-MM-dd HH:mm:ss", propertyValue);
                    break;
                case String.class:
                    return propertyValue;
                    break;
            }
        }

        return propertyValue;
    }

    /**
     * Create object in DB
     * @param -object to be saved
     * @return -saved object
     */
    public Object create(Object obj) {
        obj.save()
        return obj
    }

    /**
     * Updates object in DB
     * @param object to persist
     * @return -updated object
     */
    public Object update(Object obj) {
        obj.save()
        return obj
    }

    /**
     * Deletes object from database
     * @param object to delete
     */
    public void delete(Object obj) {
        obj.delete()
    }


    /**
     * Following method adds the Unselected Object with proper key sets for kendo datasource
     * @param lst -the main list with objects
     * @param textMember - optional value, default is 'name'
     * @return - the main List with unselected value added in first index
     */

    public static final List listForKendoDropdown(List lst, String textMember, String unselectedText) {
        List lstReturn = []
        Map unseledtedVal = new LinkedHashMap()
        String txtMember = textMember ? textMember : NAME
        String unselectedTxt = unselectedText ? unselectedText : PLEASE_SELECT_LEVEL
        if (lst.size() == 0) {
            unseledtedVal.put(ID, EMPTY_SPACE)
            unseledtedVal.put(txtMember, unselectedTxt)
            lstReturn.add(0, unseledtedVal)
            return lstReturn
        }
        // List is not empty. iterate through each key (except id & textMember)
        // Put these keys (if any) inside unselectedVal (with empty string) for consistency
        Map<String, Object> firstObj
        Object tmp = lst[0]     // pick the first element, assuming all are same
        if (tmp instanceof Map) {
            firstObj = (Map<String, Object>) tmp // groovyRowResult
        } else {
            firstObj = (Map<String, Object>) tmp.properties   // Domains
        }

        for (String key : firstObj.keySet()) {
            unseledtedVal.put(key, EMPTY_SPACE)
        }
        unseledtedVal.put(ID, EMPTY_SPACE)
        unseledtedVal.put(txtMember, unselectedTxt)
        lstReturn.add(0, unseledtedVal)
        lstReturn = lstReturn.plus(1, lst)
        // append the original list (& return a new list in case cache utility object)
        return lstReturn
    }
    public static boolean isInteger(String s) {
        try {
            Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return false;
        } catch (NullPointerException e) {
            return false;
        }
        return true;
    }

}
