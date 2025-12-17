import AnimatedButton from "../components/AnimatedButton"
import usePortfolio from "../hooks/usePortfolio"

export default function Home() {
  const { data, loading } = usePortfolio()

  // Safety check for data structure
  if (!data || !data.personal) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-white pt-20">
        <div className="text-center px-4">
          <p className="text-xl text-gray-600">Loading portfolio data...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-white pt-20">
      <div className="text-center px-4">
        <h1 className="text-5xl md:text-6xl font-bold mb-4 text-gray-900">{data.personal.name || 'Portfolio'}</h1>
        <p className="text-xl text-gray-600 mb-8">{data.personal.title || ''}</p>

        <div className="flex justify-center gap-4">
          <AnimatedButton onClick={() => window.location.href = '#projects'}>
            View Projects
          </AnimatedButton>
          <AnimatedButton onClick={() => window.location.href = `mailto:${data.personal.email}`}>
            Contact
          </AnimatedButton>
        </div>

        {loading && <p className="mt-6 text-sm text-gray-500">Loading portfolio...</p>}
      </div>
    </div>
  )
}
