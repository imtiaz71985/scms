<script type="text/x-kendo-template" id="detailsTemplate">
                <table class="table borderless">
                    <tbody>
                    <tr>
                        <td width="15%"><h5>Name</h5></td><td width="1%"><h5>:</h5></td>
                        <td width="35%"><h5>#= patient_name#</h5></td>
                        <td width="15%"><h5>Reg No</h5></td><td><h5>:</h5></td>
                        <td><h5>#= reg_no#</h5></td>
                    </tr>
                    <tr>
                        <td width="15%">Age</td><td width="1%">:</td>
                        <td width="35%">#= evaluateDateRange(new Date(date_of_birth), new Date())#</td>
                        <td>Address</td><td>:</td>
                        <td>#= address#</td>
                    </tr>
                    <tr>
                        <th colspan="12">Service Information</th>
                     </tr>
                    <tr>
                        <td>Service No</td><td>:</td>
                        <td>#= service_token_no#</td>
                        <td>Prescription</td><td>:</td>
                        <td>#= prescription_type?prescription_type:''#</td>
                    </tr>
                    <tr>
                        <td>Findings</td><td>:</td>
                        <td>#= disease?disease:''#</td>
                        <td>Referral center</td><td>:</td>
                        <td>#= referral_center?referral_center:''#</td>
                    </tr>
                    </tbody>
                </table>
            </div>
      </script>
