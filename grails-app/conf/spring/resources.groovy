import org.springframework.security.core.session.SessionRegistryImpl
import org.springframework.security.web.authentication.session.ConcurrentSessionControlStrategy
import org.springframework.security.web.session.ConcurrentSessionFilter

// Place your Spring DSL code here
beans = {
    groovySql(groovy.sql.Sql, ref('dataSource'))
    groovySql_mis(groovy.sql.Sql, ref('dataSource_mis'))
    groovySql_comn(groovy.sql.Sql, ref('dataSource_comn'))

    sessionRegistry(SessionRegistryImpl)

    sessionAuthenticationStrategy(ConcurrentSessionControlStrategy, sessionRegistry) {
        maximumSessions = -1
    }

    concurrentSessionFilter(ConcurrentSessionFilter){
        sessionRegistry = sessionRegistry
        expiredUrl = '/login/denied'
    }
}
