#import <Foundation/Foundation.h>

extern "C" {
    void ruby_sysinit(int *, char ***);
    void ruby_init(void);
    void ruby_init_loadpath(void);
    void ruby_script(const char *);
    void ruby_set_argv(int, char **);
    void rb_vm_init_compiler(void);
    void rb_vm_init_jit(void);
    void rb_vm_aot_feature_provide(const char *, void *);
    void *rb_vm_top_self(void);
    void rb_define_global_const(const char *, void *);
    void rb_rb2oc_exc_handler(void);
    void rb_exit(int);
void MREP_C586A8A5DC9F4201BC0AD3F14123EDC4(void *, void *);
void MREP_38F79ADB21D04C7B86F05140CD1D9FE0(void *, void *);
void MREP_3B08DDAA5B8A491897A79875E6311090(void *, void *);
void MREP_5C6CC7861F134FDB96CA25DC2AB0B485(void *, void *);
void MREP_523CAA86CD0E4297BB63A4902378B229(void *, void *);
void MREP_90FA8CEB42D7487AB80200131D33C537(void *, void *);
void MREP_2810D70AF28B4C37975109C1F9C12222(void *, void *);
void MREP_4ACE03E46E354AAC8ED3160835A14C4F(void *, void *);
}

extern "C"
void
RubyMotionInit(int argc, char **argv)
{
    static bool initialized = false;
    if (!initialized) {
	ruby_init();
	ruby_init_loadpath();
        if (argc > 0) {
	    const char *progname = argv[0];
	    ruby_script(progname);
	}
#if !__LP64__
	try {
#endif
	    void *self = rb_vm_top_self();
rb_define_global_const("RUBYMOTION_ENV", @"development");
rb_define_global_const("RUBYMOTION_VERSION", @"3.6");
MREP_C586A8A5DC9F4201BC0AD3F14123EDC4(self, 0);
MREP_38F79ADB21D04C7B86F05140CD1D9FE0(self, 0);
MREP_3B08DDAA5B8A491897A79875E6311090(self, 0);
MREP_5C6CC7861F134FDB96CA25DC2AB0B485(self, 0);
MREP_523CAA86CD0E4297BB63A4902378B229(self, 0);
MREP_90FA8CEB42D7487AB80200131D33C537(self, 0);
MREP_2810D70AF28B4C37975109C1F9C12222(self, 0);
MREP_4ACE03E46E354AAC8ED3160835A14C4F(self, 0);
#if !__LP64__
	}
	catch (...) {
	    rb_rb2oc_exc_handler();
	}
#endif
	initialized = true;
    }
}
