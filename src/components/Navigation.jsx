export default function Navigation() {
  return (
    <nav className="bg-white border-b fixed w-full top-0 z-40 shadow-sm">
      <div className="container mx-auto px-4 py-4 flex items-center justify-between">
        <h1 className="text-2xl font-bold text-gray-900">Portfolio</h1>
        <div className="flex items-center gap-4">
          <a href="#contact" className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition">Contact</a>
        </div>
      </div>
    </nav>
  )
}
