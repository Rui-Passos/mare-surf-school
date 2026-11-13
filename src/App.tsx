import { useEffect, useState } from 'react'
import { supabase } from './lib/supabase'

interface Lesson {
  id: string
  name: string
  description: string
  price_cents: number
  max_capacity: number
}

function App() {
  const [lessons, setLessons] = useState<Lesson[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function fetchLessons() {
      const { data, error } = await supabase.from('lessons').select('*')
      
      if (error) {
        console.error('Erro ao buscar aulas:', error)
      } else {
        setLessons(data || [])
      }
      setLoading(false)
    }

    fetchLessons()
  }, [])

  return (
    <div style={{ fontFamily: 'sans-serif', maxWidth: '800px', margin: '40px auto', padding: '0 20px' }}>
      <h1>🌊 Maré Escola de Surf</h1>
      <p>Bem-vindo ao portal de reservas. Ligação ao Supabase bem-sucedida!</p>

      <h2>Aulas Disponíveis:</h2>
      {loading ? (
        <p>A carregar aulas da base de dados...</p>
      ) : lessons.length === 0 ? (
        <p>Ainda não existem aulas cadastradas.</p>
      ) : (
        <ul>
          {lessons.map((lesson) => (
            <li key={lesson.id} style={{ marginBottom: '16px', background: '#f9f9f9', padding: '16px', borderRadius: '8px', border: '1px solid #ddd' }}>
              <strong>{lesson.name}</strong>
              <p>{lesson.description}</p>
              <span>Preço: {lesson.price_cents / 100}€ | Vagas máximas: {lesson.max_capacity}</span>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}

export default App