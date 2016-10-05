package actions.reports

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class ListMonthlyDetailsActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        return params
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            String dateStr = result.month.toString()
            Calendar c = Calendar.getInstance();
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
            Date date = originalFormat.parse(dateStr);
            c.setTime(date);
            Calendar ce = Calendar.getInstance();
            ce.setTime(date);
            ce.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));

            String fromDate = DateUtility.getDBDateFormatAsString(c.getTime())
            String toDate = DateUtility.getDBDateFormatAsString(ce.getTime())

            GrailsParameterMap parameterMap = (GrailsParameterMap) result
            initListing(parameterMap)

            String hospitalCode = parameterMap.hospitalCode
            LinkedHashMap resultMap = getMonthlyStatus(fromDate, toDate, hospitalCode)
            List<GroovyRowResult> lst = resultMap.rowResults
            result.put(LIST, lst)
            result.put(COUNT, resultMap.count)
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    private LinkedHashMap getMonthlyStatus(String fromDate, String toDate, String hospitalCode) {

        String queryStr1 = """
        SELECT c.id, c.version,c.date_field,c.is_holiday,c.holiday_status,
            CEIL(COALESCE((SELECT SUM(msi.total_amount) FROM medicine_sell_info msi
            WHERE msi.sell_date = c.date_field AND msi.hospital_code =  ${hospitalCode}
            GROUP BY msi.sell_date ),0)) AS medicine_sales,

            COALESCE((SELECT SUM(mr.total_amount) FROM medicine_return mr
            WHERE mr.return_date = c.date_field AND mr.hospital_code =  ${hospitalCode}
            GROUP BY mr.return_date ),0) AS return_amt,

                COALESCE((SELECT SUM(sc.charge_amount) FROM
                  registration_info ri LEFT JOIN service_charges sc ON sc.id = ri.service_charge_id
                WHERE DATE(ri.create_date) = c.date_field AND ri.hospital_code =  ${hospitalCode}  AND ri.is_old_patient<> TRUE
                GROUP BY DATE(ri.create_date))
                ,0) AS registration_amount,

                 COALESCE((SELECT SUM(sc4.charge_amount) FROM registration_reissue rr
                    LEFT JOIN service_charges sc4 ON sc4.id = rr.service_charge_id
                    WHERE DATE_FORMAT(rr.create_date,'%Y-%m-%d') = c.date_field AND LEFT(rr.reg_no,2) =  ${hospitalCode}
                    GROUP BY DATE_FORMAT(rr.create_date,'%Y-%m-%d')),0) AS re_registration_amount,

                COALESCE((SELECT SUM(sc2.charge_amount) FROM token_and_charge_mapping tcm2
                JOIN service_token_info sti ON sti.service_token_no=tcm2.service_token_no AND sti.is_deleted <> TRUE
                LEFT JOIN service_charges sc2 ON sc2.id = tcm2.service_charge_id AND SUBSTRING(sc2.service_code, 1,2) = '02'
                WHERE  DATE_FORMAT(tcm2.create_date,'%Y-%m-%d') = c.date_field
                AND SUBSTRING(tcm2.service_token_no, 2, 2) =  ${hospitalCode}
                GROUP BY DATE_FORMAT(tcm2.create_date,'%Y-%m-%d')),0) AS consultation_amount,

                (COALESCE((SELECT COUNT(tcm2.service_token_no) FROM token_and_charge_mapping tcm2
                JOIN service_token_info sti ON sti.service_token_no=tcm2.service_token_no
                INNER JOIN service_charges sc2 ON sc2.id = tcm2.service_charge_id AND SUBSTRING(sc2.service_code, 1,2) = '02'
                WHERE sti.is_deleted <> TRUE AND DATE_FORMAT(tcm2.create_date,'%Y-%m-%d') = c.date_field
                 AND SUBSTRING(tcm2.service_token_no, 2, 2) =  ${hospitalCode}
                GROUP BY DATE_FORMAT(tcm2.create_date,'%Y-%m-%d')),0)+

                COALESCE((SELECT COUNT(sc3.id)
                 FROM token_and_charge_mapping tcm3
                 JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no
                RIGHT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '04'
                WHERE sti.is_deleted <> TRUE AND DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field
                AND SUBSTRING(tcm3.service_token_no, 2, 2) =  ${hospitalCode}
                GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0) )AS consultation_count,

                COALESCE((SELECT SUM(sti.subsidy_amount)
                FROM service_token_info sti
                        WHERE sti.is_deleted <> TRUE AND DATE_FORMAT(sti.service_date,'%Y-%m-%d') = c.date_field
                        AND SUBSTRING(sti.service_token_no, 2, 2) =  ${hospitalCode}
                        GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d')),0) AS subsidy_amount,

                COALESCE((SELECT COUNT(sti.service_token_no)
                FROM service_token_info sti
                        WHERE sti.is_deleted <> TRUE AND DATE_FORMAT(sti.service_date,'%Y-%m-%d') = c.date_field AND sti.subsidy_amount > 0
                        AND SUBSTRING(sti.service_token_no, 2, 2) =  ${hospitalCode}
                        GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d')),0) AS subsidy_count,

                COALESCE((SELECT SUM(sc3.charge_amount)
                         FROM token_and_charge_mapping tcm3
                         JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no AND sti.is_deleted <> TRUE
                        LEFT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '03'
                        WHERE DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field
                        AND SUBSTRING(tcm3.service_token_no, 2, 2) =  ${hospitalCode}
                        GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0) AS pathology_amount,

                COALESCE((SELECT COUNT(sc3.id)
                         FROM token_and_charge_mapping tcm3
                         JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no AND sti.is_deleted <> TRUE
                        RIGHT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '03'
                        WHERE DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field
                        AND SUBSTRING(tcm3.service_token_no, 2, 2) =  ${hospitalCode}
                        GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0) AS pathology_count,

                    COALESCE((SELECT COUNT(ri.reg_no) FROM registration_info ri
                    WHERE DATE(ri.create_date) = c.date_field AND ri.hospital_code =  ${hospitalCode}  AND ri.is_old_patient <> TRUE GROUP BY DATE(ri.create_date) ),0) AS new_patient,

                COALESCE((SELECT COUNT(rri.id) FROM registration_reissue rri
                    WHERE DATE_FORMAT(rri.create_date,'%Y-%m-%d') = c.date_field AND LEFT(rri.reg_no,2) =  ${hospitalCode}
                    GROUP BY DATE_FORMAT(rri.create_date,'%Y-%m-%d') ),0) AS re_reg_patient,

                COALESCE((SELECT COUNT(sti.service_token_no) FROM service_token_info sti
                    WHERE sti.visit_type_id = 2 AND DATE_FORMAT(sti.service_date,'%Y-%m-%d')= c.date_field
                    AND SUBSTRING(sti.service_token_no, 2, 2) =  ${hospitalCode}  AND sti.is_deleted <> TRUE
                    GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d') ),0) AS patient_revisit,

                COALESCE((SELECT COUNT(sti.service_token_no) FROM service_token_info sti
                    WHERE sti.visit_type_id = 3 AND DATE_FORMAT(sti.service_date,'%Y-%m-%d')= c.date_field
                    AND SUBSTRING(sti.service_token_no, 2, 2) =  ${hospitalCode}  AND sti.is_deleted <> TRUE
                    GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d') ),0) AS patient_followup,

                (COALESCE((SELECT COUNT(ri.reg_no) FROM registration_info ri
                WHERE DATE(ri.create_date) = c.date_field AND ri.hospital_code =  ${hospitalCode}  AND ri.is_old_patient <> TRUE GROUP BY DATE(ri.create_date) ),0) +

                COALESCE((SELECT COUNT(sti.service_token_no) FROM service_token_info sti
                WHERE sti.visit_type_id = 3 AND DATE_FORMAT(sti.service_date,'%Y-%m-%d')= c.date_field
                AND SUBSTRING(sti.service_token_no, 2, 2) =  ${hospitalCode}  AND sti.is_deleted <> TRUE
                GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d') ),0) +

                COALESCE((SELECT COUNT(sti.service_token_no) FROM service_token_info sti
                WHERE sti.visit_type_id = 2 AND DATE_FORMAT(sti.service_date,'%Y-%m-%d')= c.date_field
                AND SUBSTRING(sti.service_token_no, 2, 2) =  ${hospitalCode}  AND sti.is_deleted <> TRUE
                GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d') ),0)) AS total_patient,

                (COALESCE((SELECT COUNT(ri.reg_no) FROM registration_info ri
                    WHERE DATE(ri.create_date) = c.date_field AND ri.hospital_code =  ${hospitalCode}  AND ri.is_old_patient <> TRUE GROUP BY DATE(ri.create_date) ),0) +

                COALESCE((SELECT COUNT(rri.id) FROM registration_reissue rri
                    WHERE DATE_FORMAT(rri.create_date,'%Y-%m-%d') = c.date_field
                    AND LEFT(rri.reg_no,2) = ${hospitalCode}
                    GROUP BY DATE_FORMAT(rri.create_date,'%Y-%m-%d') ),0) +

                COALESCE((SELECT COUNT(tcm2.service_token_no) FROM token_and_charge_mapping tcm2
                 JOIN service_token_info sti ON sti.service_token_no=tcm2.service_token_no AND sti.is_deleted <> TRUE
                INNER JOIN service_charges sc2 ON sc2.id = tcm2.service_charge_id AND SUBSTRING(sc2.service_code, 1,2) = '02'
                WHERE DATE_FORMAT(tcm2.create_date,'%Y-%m-%d') = c.date_field
                AND SUBSTRING(tcm2.service_token_no, 2, 2) = ${hospitalCode}
                GROUP BY DATE_FORMAT(tcm2.create_date,'%Y-%m-%d')),0) +

                COALESCE((SELECT COUNT(sc3.id)
                FROM token_and_charge_mapping tcm3
                JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no AND sti.is_deleted <> TRUE
                RIGHT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '03'
                WHERE DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field
                AND SUBSTRING(tcm3.service_token_no, 2, 2) = ${hospitalCode}
                GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0)+

                COALESCE((SELECT COUNT(sc3.id)
                    FROM token_and_charge_mapping tcm3
                JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no AND sti.is_deleted <> TRUE
                RIGHT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '04'
                WHERE DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field
                AND SUBSTRING(tcm3.service_token_no, 2, 2) = ${hospitalCode}
                GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0)+

                COALESCE((SELECT COUNT(sc3.id)
                        FROM token_and_charge_mapping tcm3
                JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no AND sti.is_deleted <> TRUE
                RIGHT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '05'
                WHERE DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field
                AND SUBSTRING(tcm3.service_token_no, 2, 2) = ${hospitalCode}
                GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0)) AS total_service

                FROM calendar c
            WHERE c.date_field BETWEEN :fromDate AND :toDate

        """
        String queryStr2 = """
        SELECT c.id, c.version,c.date_field,c.is_holiday,c.holiday_status,
            CEIL(COALESCE((SELECT SUM(msi.total_amount) FROM medicine_sell_info msi
            WHERE msi.sell_date = c.date_field
            GROUP BY msi.sell_date ),0)) AS medicine_sales,

            COALESCE((SELECT SUM(mr.total_amount) FROM medicine_return mr
            WHERE mr.return_date = c.date_field
            GROUP BY mr.return_date ),0) AS return_amt,

                COALESCE((SELECT SUM(sc.charge_amount) FROM
                  registration_info ri LEFT JOIN service_charges sc ON sc.id = ri.service_charge_id
                WHERE DATE(ri.create_date) = c.date_field  AND ri.is_old_patient<> TRUE
                GROUP BY DATE(ri.create_date))
                ,0) AS registration_amount,

                COALESCE((SELECT SUM(sc4.charge_amount) FROM registration_reissue rr
                  LEFT JOIN service_charges sc4 ON sc4.id = rr.service_charge_id
                  WHERE DATE_FORMAT(rr.create_date,'%Y-%m-%d') = c.date_field
                  GROUP BY DATE_FORMAT(rr.create_date,'%Y-%m-%d')),0) AS re_registration_amount,

                COALESCE((SELECT SUM(sc2.charge_amount) FROM token_and_charge_mapping tcm2
                JOIN service_token_info sti ON sti.service_token_no=tcm2.service_token_no AND sti.is_deleted <> TRUE
                LEFT JOIN service_charges sc2 ON sc2.id = tcm2.service_charge_id AND SUBSTRING(sc2.service_code, 1,2) = '02'
                WHERE  DATE_FORMAT(tcm2.create_date,'%Y-%m-%d') = c.date_field
                GROUP BY DATE_FORMAT(tcm2.create_date,'%Y-%m-%d')),0) AS consultation_amount,

                (COALESCE((SELECT COUNT(tcm2.service_token_no) FROM token_and_charge_mapping tcm2
                JOIN service_token_info sti ON sti.service_token_no=tcm2.service_token_no
                INNER JOIN service_charges sc2 ON sc2.id = tcm2.service_charge_id AND SUBSTRING(sc2.service_code, 1,2) = '02'
                WHERE sti.is_deleted <> TRUE AND DATE_FORMAT(tcm2.create_date,'%Y-%m-%d') = c.date_field
                GROUP BY DATE_FORMAT(tcm2.create_date,'%Y-%m-%d')),0)+

                COALESCE((SELECT COUNT(sc3.id)
                 FROM token_and_charge_mapping tcm3
                 JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no
                RIGHT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '04'
                WHERE sti.is_deleted <> TRUE AND DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field

                GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0) )AS consultation_count,

                COALESCE((SELECT SUM(sti.subsidy_amount)
                FROM service_token_info sti
                        WHERE sti.is_deleted <> TRUE AND DATE_FORMAT(sti.service_date,'%Y-%m-%d') = c.date_field

                        GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d')),0) AS subsidy_amount,

                COALESCE((SELECT COUNT(sti.service_token_no)
                FROM service_token_info sti
                        WHERE sti.is_deleted <> TRUE AND DATE_FORMAT(sti.service_date,'%Y-%m-%d') = c.date_field AND sti.subsidy_amount > 0

                        GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d')),0) AS subsidy_count,

                COALESCE((SELECT SUM(sc3.charge_amount)
                         FROM token_and_charge_mapping tcm3
                         JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no AND sti.is_deleted <> TRUE
                        LEFT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '03'
                        WHERE DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field

                        GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0) AS pathology_amount,

                COALESCE((SELECT COUNT(sc3.id)
                         FROM token_and_charge_mapping tcm3
                         JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no AND sti.is_deleted <> TRUE
                        RIGHT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '03'
                        WHERE DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field

                        GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0) AS pathology_count,

                    COALESCE((SELECT COUNT(ri.reg_no) FROM registration_info ri
                    WHERE DATE(ri.create_date) = c.date_field AND ri.is_old_patient <> TRUE GROUP BY DATE(ri.create_date) ),0) AS new_patient,

                COALESCE((SELECT COUNT(rri.id) FROM registration_reissue rri
                    WHERE DATE_FORMAT(rri.create_date,'%Y-%m-%d') = c.date_field
                    GROUP BY DATE_FORMAT(rri.create_date,'%Y-%m-%d') ),0) AS re_reg_patient,

                COALESCE((SELECT COUNT(sti.service_token_no) FROM service_token_info sti
                    WHERE sti.visit_type_id = 2 AND DATE_FORMAT(sti.service_date,'%Y-%m-%d')= c.date_field
                    AND sti.is_deleted <> TRUE
                    GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d') ),0) AS patient_revisit,

                COALESCE((SELECT COUNT(sti.service_token_no) FROM service_token_info sti
                    WHERE sti.visit_type_id = 3 AND DATE_FORMAT(sti.service_date,'%Y-%m-%d')= c.date_field
                     AND sti.is_deleted <> TRUE
                    GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d') ),0) AS patient_followup,

                (COALESCE((SELECT COUNT(ri.reg_no) FROM registration_info ri
                WHERE DATE(ri.create_date) = c.date_field AND ri.is_old_patient <> TRUE GROUP BY DATE(ri.create_date) ),0) +

                COALESCE((SELECT COUNT(sti.service_token_no) FROM service_token_info sti
                WHERE sti.visit_type_id = 3 AND DATE_FORMAT(sti.service_date,'%Y-%m-%d')= c.date_field
                 AND sti.is_deleted <> TRUE
                GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d') ),0) +

                COALESCE((SELECT COUNT(sti.service_token_no) FROM service_token_info sti
                WHERE sti.visit_type_id = 2 AND DATE_FORMAT(sti.service_date,'%Y-%m-%d')= c.date_field
                 AND sti.is_deleted <> TRUE
                GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d') ),0)) AS total_patient,

                (COALESCE((SELECT COUNT(ri.reg_no) FROM registration_info ri
                    WHERE DATE(ri.create_date) = c.date_field  AND ri.is_old_patient <> TRUE GROUP BY DATE(ri.create_date) ),0) +

                COALESCE((SELECT COUNT(rri.id) FROM registration_reissue rri
                    WHERE DATE_FORMAT(rri.create_date,'%Y-%m-%d') = c.date_field
                    GROUP BY DATE_FORMAT(rri.create_date,'%Y-%m-%d') ),0) +

                COALESCE((SELECT COUNT(tcm2.service_token_no) FROM token_and_charge_mapping tcm2
                 JOIN service_token_info sti ON sti.service_token_no=tcm2.service_token_no AND sti.is_deleted <> TRUE
                INNER JOIN service_charges sc2 ON sc2.id = tcm2.service_charge_id AND SUBSTRING(sc2.service_code, 1,2) = '02'
                WHERE DATE_FORMAT(tcm2.create_date,'%Y-%m-%d') = c.date_field
                GROUP BY DATE_FORMAT(tcm2.create_date,'%Y-%m-%d')),0) +

                COALESCE((SELECT COUNT(sc3.id)
                FROM token_and_charge_mapping tcm3
                JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no AND sti.is_deleted <> TRUE
                RIGHT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '03'
                WHERE DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field
                GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0)+

                COALESCE((SELECT COUNT(sc3.id)
                    FROM token_and_charge_mapping tcm3
                JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no AND sti.is_deleted <> TRUE
                RIGHT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '04'
                WHERE DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field
                GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0)+

                COALESCE((SELECT COUNT(sc3.id)
                        FROM token_and_charge_mapping tcm3
                JOIN service_token_info sti ON sti.service_token_no=tcm3.service_token_no AND sti.is_deleted <> TRUE
                RIGHT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '05'
                WHERE DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field
                GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0)) AS total_service

                FROM calendar c
                WHERE c.date_field BETWEEN :fromDate AND :toDate
        """

        String queryCount = """
            SELECT COUNT(c.id) AS count
                FROM calendar c
            WHERE c.date_field BETWEEN :fromDate AND :toDate
        """

        Map queryParams = [
                fromDate    : fromDate,
                toDate      : toDate,
                hospitalCode: hospitalCode
        ]

        String queryString = EMPTY_SPACE
        if (hospitalCode.equals(EMPTY_SPACE)) {
            queryString = queryStr2
        } else {
            queryString = queryStr1
        }

        List<GroovyRowResult> rowResults = executeSelectSql(queryString, queryParams)
        List countResults = executeSelectSql(queryCount, queryParams)
        int count = countResults[0].count
        return [rowResults: rowResults, count: count]
    }
    /**
     * There is no postCondition, so return the same map as received
     *
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * Since there is no success message return the same map
     * @param result -map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        return result
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     * @param result -map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }
}
