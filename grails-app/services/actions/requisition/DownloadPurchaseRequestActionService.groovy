package actions.requisition

import com.scms.HospitalLocation
import com.scms.Requisition
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.codehaus.groovy.grails.plugins.jasper.JasperExportFormat
import org.codehaus.groovy.grails.plugins.jasper.JasperReportDef
import org.codehaus.groovy.grails.plugins.jasper.JasperService
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class DownloadPurchaseRequestActionService extends BaseService implements ActionServiceIntf {

    JasperService jasperService
    SpringSecurityService springSecurityService

    private static final String REPORT_FOLDER = 'requisition'
    private static final String JASPER_FILE = 'purchaseRequestReport'
    private static final String REPORT_TITLE_LBL = 'reportTitle'
    private static final String REPORT_TITLE = 'Medicine Requisition'
    private static final String OUTPUT_FILE_NAME = "medicine_requisition"
    private static final String REQUISITION_NO = "requisitionNo"
    private static final String HOSPITAL_NAME = "hospitalName"

    /**
     * Get parameters from UI
     * @param parameters -serialized parameter from UI
     * @param obj -N/A
     * @return -a map containing necessary information for execute
     * map contains isError(true/false) depending on method success
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        if (!params.requisitionNo) {
            return super.setError(params, INVALID_INPUT_MSG)
        }

        Requisition requisition = Requisition.findByReqNo(params.requisitionNo.toString())
        HospitalLocation location = HospitalLocation.findByCode(requisition.hospitalCode)
        params.put(REQUISITION_NO, params.requisitionNo)
        params.put(HOSPITAL_NAME, location.name)
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
            Requisition requisition= Requisition.findByReqNo( result.get(REQUISITION_NO))
            if(!requisition.isGeneratePR) {
                requisition.isGeneratePR = true
                requisition.save()
            }
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
        reportParams.put(REQUISITION_NO, result.get(REQUISITION_NO))
        reportParams.put(HOSPITAL_NAME, result.get(HOSPITAL_NAME))
        JasperReportDef reportDef = new JasperReportDef(name: JASPER_FILE, fileFormat: JasperExportFormat.PDF_FORMAT,
                parameters: reportParams, folder: reportDir)
        ByteArrayOutputStream report = jasperService.generateReport(reportDef)
        return [report: report, reportFileName: outputFileName, format: REPORT_FILE_FORMAT]
    }
}
