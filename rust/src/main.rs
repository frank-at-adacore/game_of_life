use relm4::{ComponentParts, ComponentSender, RelmApp, SimpleComponent};
use relm4::gtk;
// 👑 THE CRUCIAL FIX: Bring the GTK extension traits into scope!
use relm4::gtk::prelude::*; 

struct App;

#[relm4::component]
impl SimpleComponent for App {
    type Init = ();
    type Input = ();
    type Output = ();

    view! {
        gtk::Window {
            set_title: Some("Relm4 on Windows!"),
            set_default_width: 300,
            set_default_height: 100,
            
            gtk::Label {
                set_label: "It works perfectly!",
            }
        }
    }

    fn init(init: Self::Init, root: Self::Root, sender: ComponentSender<Self>) -> ComponentParts<Self> {
        let model = App;
        let widgets = view_output!();

        ComponentParts {
            model,
            widgets,
        }
    }
}

fn main() {
    let app = RelmApp::new("com.example.relm4_win");
    app.run::<App>(());
}
