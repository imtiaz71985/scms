package com.model

class ListServiceTokenInfoWithRegInfoActionServiceModel {

        public static final String MODEL_NAME = 'list_service_token_info_with_reg_info_action_service_model'
        public static final String SQL_LIST_SERVICE_TOKEN_INFO_MODEL = """
         CREATE OR REPLACE VIEW list_service_token_info_with_reg_info_action_service_model AS
                  SELECT SUBSTR(sti.service_token_no, 2) AS id,0 AS VERSION,sti.service_token_no AS service_token_no,sti.visit_type_id, ri.date_of_birth,ri.father_or_mother_name,ri.patient_name,ri.reg_no,SUBSTRING(ri.reg_no,1,2) AS hospital_code,ri.mobile_no,
                  CONCAT('Vill:',v.name,', Union:',u.name,', Upazila:',up.name,', Dist:',d.name) AS address,ri.create_date AS registration_date,sti.service_date,
                  se.name AS marital_status,ri.marital_status_id,se1.name AS sex,ri.sex_id,ri.village_id AS village,u.id AS union_id,up.id AS upazila_id,d.id AS district_id
                  FROM service_token_info sti
                  LEFT JOIN registration_info ri ON sti.reg_no = ri.reg_no
                  LEFT JOIN village v ON ri.village_id=v.id
                  LEFT JOIN st_union u ON v.union_id=u.id
                  LEFT JOIN upazila up ON u.upazila_id=up.id
                  LEFT JOIN district d ON up.district_id=d.id
                  LEFT JOIN system_entity se ON ri.marital_status_id=se.id
                  LEFT JOIN system_entity se1 ON ri.sex_id=se1.id
                  WHERE ri.is_active!=FALSE
                  ORDER BY ri.create_date DESC;
    """

        long id
        long version
        String regNo
        String serviceTokenNo
        long visitTypeId
        String hospitalCode
        String patientName
        String fatherOrMotherName
        String dateOfBirth
        String sexId
        String maritalStatusId
        String sex
        String maritalStatus
        String mobileNo
        String address
        long village
        long unionId
        long upazilaId
        long districtId
        Date registrationDate
        Date serviceDate

        static mapping = {
            cache usage: "read-only"
        }
        static constraints = {
        }
    }
