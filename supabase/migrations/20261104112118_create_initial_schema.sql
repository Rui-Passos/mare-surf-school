-- ==========================================
-- 1. TABELA: lessons
-- Tipos de aulas disponíveis na escola
-- ==========================================

CREATE TABLE public.lessons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(100) NOT NULL,
    description TEXT,
    level VARCHAR(50) NOT NULL,

    duration_minutes INTEGER NOT NULL
        CHECK (duration_minutes > 0),

    price_cents INTEGER NOT NULL
        CHECK (price_cents >= 0),

    max_capacity INTEGER NOT NULL
        CHECK (max_capacity > 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==========================================
-- 2. TABELA: lesson_slots
-- Datas e horários das aulas disponíveis
-- ==========================================

CREATE TABLE public.lesson_slots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    lesson_id UUID NOT NULL
        REFERENCES public.lessons(id)
        ON DELETE RESTRICT,

    start_time TIMESTAMPTZ NOT NULL,

    available_spots INTEGER NOT NULL
        CHECK (available_spots >= 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==========================================
-- 3. TABELA: bookings
-- Reservas efetuadas pelos clientes
-- ==========================================

CREATE TABLE public.bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    slot_id UUID NOT NULL
        REFERENCES public.lesson_slots(id)
        ON DELETE RESTRICT,

    customer_name VARCHAR(150) NOT NULL,

    customer_email VARCHAR(255) NOT NULL,

    party_size INTEGER NOT NULL
        CHECK (party_size > 0),

    total_price_cents INTEGER NOT NULL
        CHECK (total_price_cents >= 0),

    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (
            status IN (
                'pending',
                'paid',
                'cancelled',
                'refunded'
            )
        ),

    stripe_session_id VARCHAR(255) UNIQUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==========================================
-- 4. ÍNDICES
-- Melhoram a pesquisa de horários e reservas
-- ==========================================

CREATE INDEX idx_lesson_slots_lesson_id
    ON public.lesson_slots(lesson_id);

CREATE INDEX idx_lesson_slots_start_time
    ON public.lesson_slots(start_time);

CREATE INDEX idx_bookings_slot_id
    ON public.bookings(slot_id);

CREATE INDEX idx_bookings_status
    ON public.bookings(status);

CREATE INDEX idx_bookings_customer_email
    ON public.bookings(customer_email);

    -- Ativar RLS nas tabelas
ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;