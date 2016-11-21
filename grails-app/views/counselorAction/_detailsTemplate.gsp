<script type="text/x-kendo-template" id="detailsTemplate">
                <table class="table borderless">
                    <tbody>

                    <tr>
                        <th colspan="12">Patient Information</th>
                    </tr>
                    <tr>
                        <td width="15%">Reg No</td><td width="1%">:</td>
                        <td width="35%">#= reg_no#</td>
                    </tr>
                    <tr>
                        <td width="15%">Name</td><td width="1%">:</td>
                        <td width="35%">#= patient_name#</td>
                        <td width="15%">Address</td><td width="1%">:</td>
                        <td width="35%">#= address#</td>
                    </tr>
                    <tr>
                        <td width="15%">Age</td><td width="1%">:</td>
                        <td width="35%">#= evaluateDateRange(new Date(date_of_birth), new Date())#</td>
                        <td width="15%">Gender</td><td width="1%">:</td>
                        <td width="35%">#= gender#</td>
                    </tr>
                    <tr>
                        <th colspan="12">Service Information</th>
                     </tr>
                    <tr>
                        <td width="15%">Service No</td><td width="1%">:</td>
                        <td width="35%">#= service_token_no#</td>
                        <td width="15%">Service Date</td><td width="1%">:</td>
                        <td width="35%">#= serviceDate#</td>
                    </tr>
                    <tr>
                        <td width="15%">Service Provider</td><td width="1%">:</td>
                        <td width="35%">#= service_provider#</td>
                        <td width="15%">Service Type</td><td>:</td>
                        <td width="35%">#= serviceType#</td>
                    </tr>
                    <tr>
                        <td width="15%">Diagnosis</td><td width="1%">:</td>
                        <td width="35%">#= disease?disease:''#</td>
                        <td width="15%">Prescription</td><td width="1%">:</td>
                        <td width="35%">#= prescription_type?prescription_type:''#</td>
                    </tr>
                    <tr>
                        <td width="15%">Pathology Name</td><td width="1%">:</td>
                        <td width="35%">#= diagnosis_info?diagnosis_info:''#</td>
                    </tr>
                    <tr>
                        <th colspan="12">Payment Information</th>
                    </tr>
                    <tr>
                        <td width="15%">Consultancy(৳)</td><td width="1%">:</td>
                        <td width="35%">#= consultancyAmt?consultancyAmt:'0'#</td>
                        <td width="15%">Subsidy(৳)</td><td width="1%">:</td>
                        <td width="35%">#= subsidyAmount?subsidyAmount:'0'#</td>
                    </tr>
                    <tr>
                        <td width="15%">Pathology(৳)</td><td width="1%">:</td>
                        <td width="35%">#= pathologyAmt?pathologyAmt:'0'#</td>
                        <td width="15%">Total(৳)</td><td width="1%">:</td>
                        <td width="35%">#= totalCharge?totalCharge:'0'#</td>
                    </tr>
                    <tr>
                        <th colspan="12">#= remarks?'Remarks':''#</th>
                    </tr>
                    <tr>
                        <td>#= remarks? remarks:''#</td>
                    </tr>
                    </tbody>
                </table>
      </script>
