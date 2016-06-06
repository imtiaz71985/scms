package scms

import actions.theme.DeleteThemeActionService
import actions.theme.ListThemeActionService
import actions.theme.UpdateThemeActionService

class ThemeController extends BaseController {

    UpdateThemeActionService updateThemeActionService
    DeleteThemeActionService deleteThemeActionService
    ListThemeActionService listThemeActionService

    def show() {
        render(view: "/theme/show")
    }

    def update() {
        renderOutput(updateThemeActionService, params)

    }
    def delete() {
        renderOutput(deleteThemeActionService, params)

    }
    def list() {
        renderOutput(listThemeActionService, params)
    }
}
