import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './styles/index.css';
import App from './app/App.jsx';
import { ThemeProvider } from './components/theme-provider.jsx';
import { Toaster as Sonner } from './components/ui/sonner.jsx';
createRoot(document.getElementById('root')).render(
  <StrictMode>
    <ThemeProvider
     attribute="class"
     defaultTheme="light"
     enableSystem
     storageKey="comm-store-theme"
     disableTransitionOnChange
     >
      <App />
      <Sonner />
    </ThemeProvider>
  </StrictMode>,
);
