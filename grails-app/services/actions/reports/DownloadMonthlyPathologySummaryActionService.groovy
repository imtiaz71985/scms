package actions.reports

import com.scms.HospitalLocation
import grails.transaction.Transactional
import org.codehaus.groovy.grails.plugins.jasper.JasperExportFormat
import org.codehaus.groovy.grails.plugins.jasper.JasperReportDef
import org.codehaus.groovy.grails.plugins.jasper.JasperService
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class DownloadMonthlyPathologySummaryActionService extends BaseService implements ActionServiceIntf {

    JasperService jasperService

    private static final String REPORT_FOLDER = 'financial'
    private static final String JASPER_FILE = 'monthlyPathologySummary'
    private static final String JASPER_FILE_LBL = 'jesperFileLbl'
    private static final String REPORT_TITLE_LBL = 'reportTitle'
    private static final String REPORT_TITLE = 'Monthly Pathology Summary'
    private static final String OUTPUT_FILE_NAME = "monthly_pathology_summary"
    private static final String FROM_DATE = "start"
    private static final String TO_DATE = "end"
    private static final String MONTH_NAME = "monthName"
    private static final String HOSPITAL_NAME = "hospitalName"
    private static final String QUERY_HOSPITAL_STR = "queryHospitalStr"
    private static final String FRIEND_SHIP_HEALTH_CLINIC = "Friendship Health Clinic"

    /**
     * Get parameters from UI
     * @param parameters -serialized parameter from UI
     * @param obj -N/A
     * @return -a map containing necessary information for execute
     * map contains isError(true/false) depending on method success
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        String fromDate, toDate
        try {
            String fromStr = params.from.toString()
            Calendar c = Calendar.getInstance();
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
            Date from = originalFormat.parse(fromStr);
            c.setTime(from);

            String toStr = params.to.toString()
            Calendar ce = Calendar.getInstance();
            Date to = originalFormat.parse(toStr);
            ce.setTime(to);
            ce.set(Calendar.DAY_OF_MONTH, ce.getActualMaximum(Calendar.DAY_OF_MONTH));

            fromDate = DateUtility.getDBDateFormatAsString(c.getTime())
            toDate = DateUtility.getDBDateFormatAsString(ce.getTime())
        } catch (Exception ex) {
        }
        String month = params.from.toString() + ' to ' + params.to.toString()
        String hospitalCode = params.hospitalCode
        String hospitalName = EMPTY_SPACE
        String jesperFile = EMPTY_SPACE
        String queryHospitalStr = " tcm.create_date BETWEEN '"+fromDate+"' AND '"+toDate+"'"
        if (hospitalCode.equals(EMPTY_SPACE)) {
            hospitalName = FRIEND_SHIP_HEALTH_CLINIC
            jesperFile = JASPER_FILE
        } else {
            hospitalName = HospitalLocation.findByCode(params.hospitalCode).name
            jesperFile = JASPER_FILE
            queryHospitalStr = queryHospitalStr + " AND SUBSTRING(sti.service_token_no,2,2) ='" + params.hospitalCode+"'"
        }

        params.put(HOSPITAL_NAME, hospitalName)
        params.put(QUERY_HOSPITAL_STR, queryHospitalStr)
        params.put(JASPER_FILE_LBL, jesperFile)
        params.put(FROM_DATE, fromDate)
        params.put(TO_DATE, toDate)
        params.put(MONTH_NAME, month)

        return params
    }

    /**
     * Generates report
     * @param params -N/A
     * @param obj -a map returned from previous method
     * @return -a map containing all necessary information for downloading report
     */
    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            Map report = getReport(result)
            result.put(REPORT, report)
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * do nothing for post operation
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * Wrap sprint details list for grid
     * @param obj -map returned from execute method
     * @return -a map containing all objects necessary for grid view
     */
    public Map buildSuccessResultForUI(Map result) {
        return result
    }

    /**
     * Build failure result in case of any error
     * @param obj -map returned from previous methods, can be null
     * @return -a map containing isError = true & relevant error message
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private Map getReport(Map result) {
        String rootDir = result.reportDirectory + File.separator
        String logoDir = result.logoDirectory + File.separator
        String reportDir = result.reportDirectory + File.separator + REPORT_FOLDER
        String subReportDir = reportDir + File.separator
        String outputFileName = OUTPUT_FILE_NAME + PDF_EXTENSION
        Map reportParams = new LinkedHashMap()
        reportParams.put(ROOT_DIR, rootDir)
        reportParams.put(LOGO_DIR, logoDir)
        reportParams.put(REPORT_DIR, reportDir)
        reportParams.put(SUBREPORT_DIR, subReportDir)
        reportParams.put(REPORT_TITLE_LBL, REPORT_TITLE)
        reportParams.put(FROM_DATE, result.get(FROM_DATE))
        reportParams.put(TO_DATE, result.get(TO_DATE))
        reportParams.put(MONTH_NAME, result.get(MONTH_NAME))
        reportParams.put(HOSPITAL_NAME, result.get(HOSPITAL_NAME))
        reportParams.put(QUERY_HOSPITAL_STR, result.get(QUERY_HOSPITAL_STR))
        JasperReportDef reportDef = new JasperReportDef(name: result.get(JASPER_FILE_LBL), fileFormat: JasperExportFormat.PDF_FORMAT,
                parameters: reportParams, folder: reportDir)
        ByteArrayOutputStream report = jasperService.generateReport(reportDef)
        return [report: report, reportFileName: outputFileName, format: REPORT_FILE_FORMAT]
    }
}
