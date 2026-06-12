/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          100: '#dbeafe',
          200: '#bfdbfe',
          300: '#93c5fd',
          400: '#60a5fa',
          500: '#1e3a5f',
          600: '#1a3050',
          700: '#152641',
          800: '#0f1c32',
          900: '#0a1223',
        },
        accent: {
          50: '#fdf8e8',
          100: '#fceec5',
          200: '#f9dd8e',
          300: '#f5c44e',
          400: '#f0ad1f',
          500: '#d4940f',
          600: '#b0780a',
        },
      },
    },
  },
  plugins: [],
};
