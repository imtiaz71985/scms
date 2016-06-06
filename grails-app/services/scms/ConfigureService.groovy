package scms

import com.model.ListSecRoleActionServiceModel
import com.model.ListSecUserActionServiceModel
import com.model.ListSecUserSecRoleActionServiceModel
import com.model.ListThemeActionServiceModel
import com.scms.FeatureManagement
import com.scms.SecRole
import com.scms.SecUser
import com.scms.SecUserSecRole
import grails.transaction.Transactional
import service.ThemeService

@Transactional
class ConfigureService extends BaseService {

    public void initSchema() {
        customExecuteSql(ListSecUserActionServiceModel.MODEL_NAME, ListSecUserActionServiceModel.SQL_LIST_SEC_USER_MODEL)
        customExecuteSql(ListSecRoleActionServiceModel.MODEL_NAME, ListSecRoleActionServiceModel.SQL_LIST_SEC_ROLE_MODEL)
        customExecuteSql(ListSecUserSecRoleActionServiceModel.MODEL_NAME, ListSecUserSecRoleActionServiceModel.SQL_LIST_USER_ROLE_MODEL)
        customExecuteSql(ListThemeActionServiceModel.MODEL_NAME, ListThemeActionServiceModel.SQL_LIST_THEME_MODEL)
    }

    public boolean customExecuteSql(String model, String query) {
        String dropTable = """ DROP TABLE IF EXISTS ${model} """
        String dropView = """ DROP VIEW IF EXISTS ${model} """
        executeSql(dropTable)
        executeSql(dropView)
        executeSql(query)
        return true;
    }

    public void initData() {
        SecUser U1 = new SecUser(username:'admin', password:'admin', enabled:true).save()
        SecRole R1 = new SecRole(name: 'Admin', authority: 'ROLE_ADMIN').save()
        SecUserSecRole.create(U1, R1)

        new FeatureManagement(url: '/login/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/logout/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/css/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/js/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/images/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/dist/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/components/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()

        new FeatureManagement(url: '/', configAttribute: 'ROLE_ADMIN', featureName: '').save()
        new FeatureManagement(url: '/secUser/show', configAttribute: 'ROLE_ADMIN', featureName: 'Show user').save()
        new FeatureManagement(url: '/secUser/create', configAttribute: 'ROLE_ADMIN', featureName: 'Create user').save()
        new FeatureManagement(url: '/secUser/update', configAttribute: 'ROLE_ADMIN', featureName: 'Update user').save()
        new FeatureManagement(url: '/secUser/delete', configAttribute: 'ROLE_ADMIN', featureName: 'Delete user').save()
        new FeatureManagement(url: '/secUser/list', configAttribute: 'ROLE_ADMIN', featureName: 'List user').save()
        new FeatureManagement(url: '/secUser/resetPassword', configAttribute: 'ROLE_ADMIN', featureName: 'Reset password').save()

        new FeatureManagement(url: '/secRole/show', configAttribute: 'ROLE_ADMIN', featureName: 'Show role').save()
        new FeatureManagement(url: '/secRole/create', configAttribute: 'ROLE_ADMIN', featureName: 'Create role').save()
        new FeatureManagement(url: '/secRole/update', configAttribute: 'ROLE_ADMIN', featureName: 'Update role').save()
        new FeatureManagement(url: '/secRole/delete', configAttribute: 'ROLE_ADMIN', featureName: 'Delete role').save()
        new FeatureManagement(url: '/secRole/list', configAttribute: 'ROLE_ADMIN', featureName: 'List role').save()

        new FeatureManagement(url: '/secUserSecRole/show', configAttribute: 'ROLE_ADMIN', featureName: 'Show user role mapping').save()
        new FeatureManagement(url: '/secUserSecRole/create', configAttribute: 'ROLE_ADMIN', featureName: 'Create user role mapping').save()
        new FeatureManagement(url: '/secUserSecRole/update', configAttribute: 'ROLE_ADMIN', featureName: 'Update user role mapping').save()
        new FeatureManagement(url: '/secUserSecRole/delete', configAttribute: 'ROLE_ADMIN', featureName: 'Delete user role mapping').save()
        new FeatureManagement(url: '/secUserSecRole/list', configAttribute: 'ROLE_ADMIN', featureName: 'List user role mapping').save()
        new FeatureManagement(url: '/secUser/reloadDropDown', configAttribute: 'ROLE_ADMIN', featureName: 'Reload user dropdown').save()
        new FeatureManagement(url: '/secUserSecRole/report', configAttribute: 'ROLE_ADMIN', featureName: 'Download user role mapping report').save()

        new FeatureManagement(url: '/featureManagement/show', configAttribute: 'ROLE_ADMIN', featureName: 'Show feature management').save()
        new FeatureManagement(url: '/featureManagement/update', configAttribute: 'ROLE_ADMIN', featureName: 'Update feature management').save()
        new FeatureManagement(url: '/featureManagement/listAvailableRole', configAttribute: 'ROLE_ADMIN', featureName: 'Available features').save()
        new FeatureManagement(url: '/featureManagement/listAssignedRole', configAttribute: 'ROLE_ADMIN', featureName: 'Assigned features').save()


        executeSql(ThemeService.INSERT_QUERY_COMMON_CSS)

    }
}
