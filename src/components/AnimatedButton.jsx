export default function AnimatedButton({ children, onClick, className = "" }) {
  return (
    <button
      onClick={onClick}
      className={`px-8 py-4 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition-all duration-300 transform hover:scale-105 active:scale-95 ${className}`}
    >
      {children}
    </button>
  )
}
