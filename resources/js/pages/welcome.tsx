import { Head, Link, usePage } from '@inertiajs/react';
import { dashboard, login, register } from '@/routes';
import { LayoutDashboard, LogIn, UserPlus, ArrowRight, Github, Twitter, Layers, Zap, Shield } from 'lucide-react';

export default function Welcome({
    canRegister = true,
}: {
    canRegister?: boolean;
}) {
    const { auth } = usePage().props;

    return (
        <>
            <Head title="Premium Experience" />

            <div className="relative min-h-screen overflow-hidden bg-[#030712] font-['Outfit',sans-serif] text-slate-200">
                {/* Background Image with Overlay */}
                <div 
                    className="absolute inset-0 bg-cover bg-center bg-no-repeat opacity-40 mix-blend-screen"
                    style={{ backgroundImage: "url('/images/hero-bg.png')" }}
                />
                
                {/* Decorative Gradients */}
                <div className="absolute top-0 -left-4 w-72 h-72 bg-purple-600 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob"></div>
                <div className="absolute top-0 -right-4 w-72 h-72 bg-blue-600 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob animation-delay-2000"></div>
                <div className="absolute -bottom-8 left-20 w-72 h-72 bg-indigo-600 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob animation-delay-4000"></div>

                <div className="relative flex min-h-screen flex-col items-center p-6 lg:p-8">
                    {/* Navigation */}
                    <header className="flex w-full max-w-7xl items-center justify-between py-6">
                        <div className="flex items-center gap-2 group cursor-pointer transition-all duration-300">
                            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-indigo-500 via-purple-500 to-pink-500 shadow-lg shadow-indigo-500/20 group-hover:scale-110 transition-transform duration-300">
                                <Layers className="h-6 w-6 text-white" />
                            </div>
                            <span className="text-xl font-bold tracking-tight text-white group-hover:bg-clip-text group-hover:text-transparent group-hover:bg-gradient-to-r group-hover:from-indigo-400 group-hover:to-purple-400 transition-all duration-300">
                                Antigravity
                            </span>
                        </div>

                        <nav className="flex items-center gap-4">
                            {auth.user ? (
                                <Link
                                    href={dashboard()}
                                    className="group relative flex items-center gap-2 overflow-hidden rounded-full bg-white/5 px-6 py-2.5 text-sm font-medium text-white backdrop-blur-md transition-all duration-300 hover:bg-white/10 hover:shadow-2xl hover:shadow-indigo-500/10 border border-white/10"
                                >
                                    <LayoutDashboard className="h-4 w-4 transition-transform group-hover:rotate-12" />
                                    <span>Dashboard</span>
                                </Link>
                            ) : (
                                <>
                                    <Link
                                        href={login()}
                                        className="text-sm font-medium text-slate-300 transition-all duration-300 hover:text-white px-4 py-2"
                                    >
                                        Log in
                                    </Link>
                                    {canRegister && (
                                        <Link
                                            href={register()}
                                            className="group relative flex items-center gap-2 overflow-hidden rounded-full bg-gradient-to-r from-indigo-600 to-purple-600 px-6 py-2.5 text-sm font-semibold text-white shadow-lg shadow-indigo-600/30 transition-all duration-300 hover:scale-105 hover:shadow-indigo-600/50 active:scale-95"
                                        >
                                            <UserPlus className="h-4 w-4" />
                                            <span>Join Now</span>
                                        </Link>
                                    )}
                                </>
                            )}
                        </nav>
                    </header>

                    {/* Hero Section */}
                    <main className="flex-1 flex flex-col items-center justify-center w-full max-w-4xl text-center">
                        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-500/10 border border-indigo-500/20 text-indigo-400 text-xs font-semibold mb-6 animate-fade-in">
                            <span className="relative flex h-2 w-2">
                                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-indigo-400 opacity-75"></span>
                                <span className="relative inline-flex rounded-full h-2 w-2 bg-indigo-500"></span>
                            </span>
                            NEW VERSION 2.0 IS LIVE
                        </div>
                        
                        <h1 className="text-5xl lg:text-8xl font-bold tracking-tight text-white mb-8 animate-slide-up leading-tight">
                            Build the <span className="bg-clip-text text-transparent bg-gradient-to-r from-indigo-400 via-purple-400 to-pink-400">Future</span> 
                            <br /> of Web Apps
                        </h1>
                        
                        <p className="max-w-2xl text-lg lg:text-xl text-slate-400 mb-12 animate-slide-up-delay">
                            The most powerful Laravel & React starter kit. Elevate your development with 
                            pre-built premium components, seamless authentication, and state-of-the-art styling.
                        </p>

                        <div className="flex flex-col sm:flex-row items-center gap-4 animate-slide-up-delay-2">
                            <Link
                                href={register()}
                                className="group flex items-center gap-2 px-8 py-4 rounded-2xl bg-white text-slate-950 font-bold transition-all duration-300 hover:bg-slate-100 hover:scale-105 active:scale-95 shadow-2xl shadow-white/10"
                            >
                                Start Building <ArrowRight className="h-5 w-5 transition-transform group-hover:translate-x-1" />
                            </Link>
                            <a
                                href="https://github.com/laravel/laravel"
                                target="_blank"
                                className="flex items-center gap-2 px-8 py-4 rounded-2xl bg-white/5 border border-white/10 text-white font-semibold backdrop-blur-md transition-all duration-300 hover:bg-white/10 hover:border-white/20 active:scale-95"
                            >
                                <Github className="h-5 w-5" /> View Source
                            </a>
                        </div>

                        {/* Features List */}
                        <div className="grid grid-cols-1 sm:grid-cols-3 gap-8 mt-24 mb-12 w-full animate-fade-in-delay-3 px-4 sm:px-0">
                            {[
                                { icon: <Zap className="h-6 w-6 text-yellow-400" />, title: "Lighting Fast", desc: "Optimized for speed and performance." },
                                { icon: <Shield className="h-6 w-6 text-green-400" />, title: "Secure by Default", desc: "Enterprise-grade safety features." },
                                { icon: <Layers className="h-6 w-6 text-purple-400" />, title: "Modular Architecture", desc: "Components built to be scaled." }
                            ].map((feature, i) => (
                                <div key={i} className="flex flex-col items-center text-center p-6 rounded-3xl bg-white/5 border border-white/10 backdrop-blur-sm transition-transform duration-300 hover:-translate-y-2">
                                    <div className="h-12 w-12 rounded-2xl bg-white/10 flex items-center justify-center mb-4">
                                        {feature.icon}
                                    </div>
                                    <h3 className="text-lg font-bold text-white mb-2">{feature.title}</h3>
                                    <p className="text-sm text-slate-400 leading-relaxed">{feature.desc}</p>
                                </div>
                            ))}
                        </div>
                    </main>

                    {/* Footer */}
                    <footer className="mt-auto w-full max-w-7xl flex flex-col sm:flex-row items-center justify-between py-12 border-t border-white/5 gap-6 sm:gap-0">
                        <div className="text-slate-500 text-sm">
                            © {new Date().getFullYear()} Antigravity. Built with precision and care.
                        </div>
                        <div className="flex items-center gap-6">
                            <a href="#" className="text-slate-400 hover:text-white transition-colors duration-200">Documentation</a>
                            <a href="#" className="text-slate-400 hover:text-white transition-colors duration-200">Showcase</a>
                            <div className="flex items-center gap-4 ml-4">
                                <Twitter className="h-5 w-5 text-slate-400 hover:text-sky-400 cursor-pointer transition-colors duration-200" />
                                <Github className="h-5 w-5 text-slate-400 hover:text-white cursor-pointer transition-colors duration-200" />
                            </div>
                        </div>
                    </footer>
                </div>

                {/* Custom Styles for Keyframe Animations */}
                <style dangerouslySetInnerHTML={{ __html: `
                    @keyframes blob {
                        0% { transform: scale(1) translate(0px, 0px); }
                        33% { transform: scale(1.1) translate(30px, -50px); }
                        66% { transform: scale(0.9) translate(-20px, 20px); }
                        100% { transform: scale(1) translate(0px, 0px); }
                    }
                    .animate-blob {
                        animation: blob 7s infinite;
                    }
                    .animation-delay-2000 {
                        animation-delay: 2s;
                    }
                    .animation-delay-4000 {
                        animation-delay: 4s;
                    }
                    .animate-fade-in { animation: fadeIn 1s ease-out forwards; }
                    .animate-slide-up { animation: slideUp 1s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
                    .animate-slide-up-delay { animation: slideUp 1.2s cubic-bezier(0.16, 1, 0.3, 1) forwards; opacity: 0; }
                    .animate-slide-up-delay-2 { animation: slideUp 1.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; opacity: 0; }
                    .animate-fade-in-delay-3 { animation: fadeIn 2s ease-out forwards; opacity: 0; }
                    
                    @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
                    @keyframes slideUp { 
                        from { opacity: 0; transform: translateY(30px) scale(0.95); } 
                        to { opacity: 1; transform: translateY(0) scale(1); } 
                    }
                `}} />
            </div>
        </>
    );
}
